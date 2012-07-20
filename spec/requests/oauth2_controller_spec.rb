require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'authorization code flow' do

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }

  let!(:params) do
    { response_type: 'code',
      client_id:     application.uid,
      redirect_uri:  application.redirect_uri,
      scope:         'public write',
      state:         'remember-me' }
  end

  describe 'when sends a valid request' do

    let(:uri) { "/oauth/authorize?#{params.to_param}" }
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

        describe 'when authorize the client' do

          before { page.click_button 'Authorize' }

          it 'redirects to the callback uri' do
            page.current_path.should == application.redirect_uri
          end
        end
      end
    end
  end
end
