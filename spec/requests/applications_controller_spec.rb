require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'applications' do

  let!(:user) { FactoryGirl.create :user }
  let!(:bob)  { FactoryGirl.create :bob }
  let!(:admin)  { FactoryGirl.create :admin }

  let!(:application)     { FactoryGirl.create :application, resource_owner_id: user.id }
  let!(:bob_application) { FactoryGirl.create :application, resource_owner_id: bob.id }

  let!(:token) { FactoryGirl.create :access_token, application: application }

  before do
    visit oauth_applications_path
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

    it 'contains the applications link' do
      page.should have_link 'Applications'
    end
  end


  describe 'show' do

    before { click_link application.name }

    it 'contains name' do
      page.should have_content application.name
    end

    it 'contains redirect uri' do
      page.should have_content application.redirect_uri
    end

    it 'contains unique id' do
      page.should have_content application.uid
    end

    it 'contains secret' do
      page.should have_content application.secret
    end

    describe 'with a not owned resource' do

      let(:uri) { oauth_application_path bob_application }

      it 'does not show the resource' do
        expect {visit uri}.to raise_error Mongoid::Errors::DocumentNotFound
      end
    end
  end


  describe 'new' do

    before { click_link 'New Application' }

    it 'contains name field' do
      page.should have_field 'Name'
    end

    it 'contains redirect uri field' do
      page.should have_field 'Redirect uri'
    end

    describe 'when fills the field' do

      before do
        fill_in 'Name',         with: 'Voice recognition'
        fill_in 'Redirect uri', with: 'http://app.com/callback'
        click_button 'Submit'
      end

      let(:new_application) { Doorkeeper::Application.last }

      it 'creates a new application' do
        page.should have_content new_application.name
      end
    end

    describe 'when fills invalid values' do

      before { click_button 'Submit' }

      it 'contains validation errors' do
        page.should have_content 'errors'
      end
    end
  end


  describe 'edit' do

    before { click_link 'Edit' }

    it 'contains name field' do
      page.should have_field 'Name'
    end

    it 'contains redirect uri field' do
      page.should have_field 'Redirect uri'
    end

    describe 'when updates the application' do

      before do
        fill_in 'Redirect uri', with: 'http://app.com/updated'
        click_button 'Submit'
      end

      it 'updates the application' do
        page.should have_content 'updated'
      end
    end

    describe 'when fills invalid values' do

      before do
        fill_in 'Redirect uri', with: 'not-valid-uri'
        click_button 'Submit'
      end

      it 'contains validation errors' do
        page.should have_content 'errors'
      end
    end

    describe 'with a not owned application' do

      let(:uri) { edit_oauth_application_path bob_application }

      it 'does not show the resource' do
        expect {visit uri}.to raise_error Mongoid::Errors::DocumentNotFound
      end
    end
  end


  describe 'delete' do

    before { click_link 'Delete' }

    it 'removes the application' do
      page.should_not have_content application.name
    end

    it 'deletes access tokens related to the application' do
      Doorkeeper::AccessToken.count.should == 0
    end

    describe 'with a not owned application' do

      let(:uri) { oauth_application_path bob_application }

      it 'does not show the resource' do
        expect { page.driver.delete uri }.to raise_error Mongoid::Errors::DocumentNotFound
      end
    end
  end


  describe 'admin' do

    before do
      click_link 'Sign out'
      click_link 'Sign in'
    end

    before do
      visit oauth_applications_path
    end

    before do
      fill_in 'Email',    with: 'admin@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
    end

    describe 'index' do

      it 'contains not owned applications' do
        page.should have_content bob_application.name
      end
    end

    describe 'show' do

      before { click_link bob_application.name }

      it 'shows the not owned resource' do
        page.should have_content bob_application.secret
      end
    end

    describe 'edit' do

      before { visit edit_oauth_application_path bob_application }

      it 'edits the not owned application' do
        page.should have_field 'Name'
      end
    end

    describe 'delete' do

      before do
        page.driver.delete oauth_application_path bob_application
      end

      it 'removes the not owned application' do
        page.should_not have_content bob_application.name
      end
    end
  end  
end
