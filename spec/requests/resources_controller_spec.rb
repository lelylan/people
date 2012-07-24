require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'resources' do

  before { cleanup }

  let!(:user)        { FactoryGirl.create :user }
  let!(:application) { FactoryGirl.create :application }
  let!(:device)      { FactoryGirl.create :device, resource_owner_id: user.id }
  let!(:location)    { FactoryGirl.create :location, :with_descendants, resource_owner_id: user.id.to_s }

  let!(:authorization_params) {{
    response_type: 'code',
    client_id:     application.uid,
    redirect_uri:  application.redirect_uri,
    scope:         'public write',
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

        describe 'when filters resources' do
          before { click_link 'Filter resources' }

          it 'shows the devices' do
            save_and_open_page
            page.should have_content device.name
          end

          it 'shows the locations' do
            page.should have_content location.name
          end
        end
      end
    end
  end  
end
