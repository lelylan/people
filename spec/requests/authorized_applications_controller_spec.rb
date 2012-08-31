require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'authorized applications' do

  let!(:user) { FactoryGirl.create :user }
  let!(:bob)  { FactoryGirl.create :bob }

  let!(:application)     { FactoryGirl.create :application, resource_owner_id: user.id }
  let!(:bob_application) { FactoryGirl.create :application, resource_owner_id: bob.id }

  let!(:token)     { FactoryGirl.create :access_token, application: application, resource_owner_id: user.id }
  let!(:bob_token) { FactoryGirl.create :access_token, application: application, resource_owner_id: bob.id }

  before do
    visit oauth_authorized_applications_path
  end

  before do
    fill_in 'Email',    with: 'alice@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'
  end


  describe 'index' do

    it 'contains the application' do
      page.should have_content application.name
    end

    it 'does not contain bob application' do
      page.should_not have_content bob_application.name
    end

    it 'contains the authorized applications link' do
      page.should have_link 'Authorized Applications'
    end
  end


  describe 'delete' do

    before { click_link 'Revoke' }

    it 'remove the application' do
      page.should_not have_content application.name
    end

    describe 'with a not owned application' do

      let(:uri) { oauth_authorized_application_path bob_application }

      it 'does not show the resource' do
        # we expected a not found record but it simply fail silently
        expect { page.driver.delete uri }.to_not change{ Doorkeeper::AccessToken.count }
      end
    end
  end
end
