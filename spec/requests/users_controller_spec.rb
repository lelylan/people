require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

describe '/signin' do

  let!(:user) { FactoryGirl.create(:user) }
  before      { visit('/users/sign_in')   }

  it 'shows the sign in page' do
    page.should have_content('Sign in')
  end

  context 'with valid email and password' do

    before do
      fill_in  'Email',    with: 'alice@example.com'
      fill_in  'Password', with: 'alice'
      click_on 'Sign in'
    end

    it 'signs in' do
      page.should have_content('Signed in successfully.')
    end
  end

  context 'with not valid email' do

    before do
      fill_in  'Email',    with: 'invalid@example.com'
      fill_in  'Password', with: 'alice'
      click_on 'Sign in'
    end

    it 'does not sign in' do
      page.should have_content('Invalid email or password.')
    end
  end

  context 'with not valid password' do

    before do
      fill_in  'Email',    with: 'alice@example.com'
      fill_in  'Password', with: 'invalid'
      click_on 'Sign in'
    end

    it 'does not sign in' do
      page.should have_content('Invalid email or password.')
    end
  end
end

describe '/signout' do

  let!(:user) { FactoryGirl.create(:user) }
  before      { visit('/users/sign_in') }

  context 'when logged in' do

    before do
      fill_in  'Email',    with: 'alice@example.com'
      fill_in  'Password', with: 'alice'
      click_on 'Sign in'
      click_on 'Sign out'
    end

    it 'signs out' do
      page.should have_content('Signed out successfully.')
    end
  end
end
