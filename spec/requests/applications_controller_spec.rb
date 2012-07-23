require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'GET /oauth/applications' do

  let!(:user) { FactoryGirl.create :user }
  let!(:bob)  { FactoryGirl.create :bob }

  let!(:application)     { FactoryGirl.create :application, resource_owner_id: user.id }
  let!(:bob_application) { FactoryGirl.create :application, resource_owner_id: bob.id }

  before do
    visit '/'
    click_link 'Applications'
  end

  before do
    fill_in 'Email',    with: 'alice@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'
  end

  it 'contains @application' do
    page.should have_content application.name
  end

  it 'should contain the menu' do
    page.should have_link 'Sign out'
  end

  it 'does not contain @bob_application' do
    page.should_not have_content bob_application.name
  end
end
