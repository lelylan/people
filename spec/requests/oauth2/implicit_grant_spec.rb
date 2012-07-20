require File.expand_path(File.dirname(__FILE__) + '/../acceptance_helper')

feature 'implicit grant flow' do

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }

  let!(:authorization_params) do
    { response_type: 'token',
      client_id:     application.uid,
      redirect_uri:  application.redirect_uri,
      scope:         'public write',
      state:         'remember-me' }
  end

  describe 'when sends an authorization request' do

    let(:uri) { "/oauth/authorize?#{authorization_params.to_param}" }
    before    { visit uri }

    describe "when not logged in" do

      it 'shows the sign in page' do
        page.should have_content 'Sign in'
      end

      describe "when signs in" do

        before do
          fill_in 'Email',    with: 'alice@example.com'
          fill_in 'Password', with: 'password'
          click_button 'Sign in'
        end

        it 'shows the grant page' do
          page.should have_content "Authorize #{application.name}"
        end

        describe 'when authorizes the client', js: true do

          before { page.click_button 'Authorize' }

          it 'redirects to the client callback uri' do
            redirect_uri = page.current_host + page.current_path
            redirect_uri.should == application.redirect_uri
            pp page.current_url
          end

          describe 'when returns the acces token representation' do

            subject(:fragment) do
              params = URI.parse(page.current_url).fragment
              Hashie::Mash.new Rack::Utils.parse_nested_query(params)
            end

            let(:token) { Doorkeeper::AccessToken.last }

            its(:access_token) { should == token.token }
            its(:expires_in)   { should == '7200' }
            its(:token_type)   { should == 'bearer' }
          end
        end
      end
    end
  end
end
