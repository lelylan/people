require File.expand_path(File.dirname(__FILE__) + '/../acceptance_helper')

feature 'GET /oauth/applications' do

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }

  before do
    visit '/'
    click_link 'Applications'
  end

  before do
    fill_in 'Email',    with: 'alice@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'
  end

  it 'should contain one application' do
    page.should have_content application.name
    save_and_open_page
  end
end
