require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')


describe '/users/signin' do

  let!(:user) { FactoryGirl.create(:user) }
  before      { visit '/users/sign_in' }

  it 'shows the sign in page' do
    page.should have_content 'Sign in'
  end

  context 'with valid email and password' do

    before do
      fill_in 'Email',    with: 'alice@example.com'
      fill_in 'Password', with: 'alice'
      click_button 'Sign in'
    end

    it 'signs in' do
      page.should have_content('Signed in successfully.')
    end
  end

  context 'with not valid email' do

    before do
      fill_in 'Email',    with: 'invalid@example.com'
      fill_in 'Password', with: 'alice'
      click_button 'Sign in'
    end

    it 'does not sign in' do
      page.should have_content('Invalid email or password.')
    end
  end

  context 'with not valid password' do

    before do
      fill_in 'Email',    with: 'alice@example.com'
      fill_in 'Password', with: 'invalid'
      click_button 'Sign in'
    end

    it 'does not sign in' do
      page.should have_content('Invalid email or password.')
    end
  end
end


describe '/users/signout' do

  let!(:user) { FactoryGirl.create(:user) }

  before do
    visit '/users/sign_in'
    fill_in 'Email',    with: 'alice@example.com'
    fill_in 'Password', with: 'alice'
    click_button 'Sign in'
  end

  before do
    click_link 'Sign out'
  end

  it 'shows the home page' do
    current_path.should == root_path
  end

  it 'signs out' do
    page.should have_content('Signed out successfully.')
  end
end


describe '/users/password/new' do

  let!(:user) { FactoryGirl.create(:user) }

  before do
    visit '/users/password/new'
  end

  it 'shows the forgot your password page' do
    page.should have_content('Forgot your password?')
  end

  describe "when user exists" do

    before do
      fill_in 'Email', with: 'alice@example.com'
      click_button 'Send me reset password instructions'
    end

    it 'send the mail for password recovery' do 
      page.should have_content('You will receive an email with instructions')
    end
  end
end
