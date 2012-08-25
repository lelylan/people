require File.expand_path(File.dirname(__FILE__) + '/../acceptance_helper')

feature 'authorization code flow' do

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }

  let!(:authorization_params) {{
    response_type: 'code',
    client_id:     application.uid,
    redirect_uri:  application.redirect_uri,
    scope:         'resources',
    state:         'remember-me'
  }}

  describe 'when sends an authorization request' do

    let(:uri) { "/oauth/authorize?#{authorization_params.to_param}" }
    before    { visit uri }

    describe 'when not logged in' do

      it 'shows the sign in page' do
        page.should have_content 'Sign in'
      end

      describe 'when signs in' do

        before do
          fill_in 'Email',    with: 'alice@example.com'
          fill_in 'Password', with: 'password'
          click_button 'Sign in'
        end

        it 'shows the grant page' do
          page.should have_content "Authorize #{application.name}"
        end

        describe 'when authorizes the client' do

          before { begin page.click_button 'Authorize' rescue ActionController::RoutingError end }

          let(:redirect_uri) { page.current_host + page.current_path }

          let!(:authorization_code) do
            query = URI.parse(page.current_url).query
            Rack::Utils.parse_nested_query(query)['code']
          end

          it 'redirects to the client callback uri' do
            redirect_uri.should == application.redirect_uri
          end

          it 'returns an activation code' do
            authorization_code.should_not be_nil
          end

          describe 'when sends an access token request' do

            let!(:access_params) do
              { grant_type:  'authorization_code',
                code:         authorization_code,
                redirect_uri: application.redirect_uri }
            end

            before do
              page.driver.browser.authorize application.uid, application.secret
              page.driver.post '/oauth/token', access_params
            end

            it 'returns valid json' do
              expect { JSON.parse(page.source) }.to_not raise_error
            end

            describe 'when returns the acces token representation' do

              let(:token)     { Doorkeeper::AccessToken.last }
              subject(:json)  { Hashie::Mash.new JSON.parse(page.source) }

              its(:access_token)  { should == token.token }
              its(:expires_in)    { should == 7200 }
              its(:token_type)    { should == 'bearer' }
              its(:refresh_token) { should == token.refresh_token }
            end
          end
        end
      end
    end
  end
end
