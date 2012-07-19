require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')


describe '/users/signin' do

  let!(:user) { FactoryGirl.create(:user) }

  before do
    # TODO should click on the button in the page
    visit '/users/sign_in'
  end

  it 'shows the sign in page' do
    page.should have_content 'Sign in'
  end

  describe 'with valid email and password' do

    before do
      fill_in 'Email',    with: 'alice@example.com'
      fill_in 'Password', with: 'alice'
      click_button 'Sign in'
    end

    it 'signs in' do
      page.should have_content('Signed in successfully.')
    end
  end

  describe 'with not valid email' do

    before do
      fill_in 'Email',    with: 'invalid@example.com'
      fill_in 'Password', with: 'alice'
      click_button 'Sign in'
    end

    it 'does not sign in' do
      page.should have_content('Invalid email or password.')
    end
  end

  describe 'with not valid password' do

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

  describe "when user does not exists" do

    before do
      fill_in 'Email', with: 'invalid@example.com'
      click_button 'Send me reset password instructions'
    end

    it 'send the mail for password recovery' do 
      page.should have_content('Email not found')
    end
  end
end


describe '/users/password/edit' do

  describe 'with valid remember token' do

    let!(:user) { FactoryGirl.create(:user) }
    before      { user.send_reset_password_instructions }
    let(:token) { user.reset_password_token }

    before do
      visit '/users/password/edit?reset_password_token=' + token
    end

    it 'shows the change password page' do
      page.should have_content('Change your password')
    end

    describe 'when fills in the new password' do

      before do
        fill_in 'New password',         with: 'reset_alice'
        fill_in 'Confirm new password', with: 'reset_alice'
        click_button 'Change my password'
      end

      it 'changes the password' do
        page.should have_content('Your password was changed successfully.')
      end
    end
  end
end


describe '/users/sign_up' do

  before do
    # TODO: should click to the link at home page
    visit '/users/sign_up'
  end

  it 'shows the sign up page' do
    page.should have_content('Sign up')
  end

  describe 'with all fields filled in' do

    before do
      fill_in 'Email',    with: 'alice@example.com'
      fill_in 'Password', with: 'alice'
      click_button 'Sign up'
    end

    it 'signs up' do
      page.should have_content 'Welcome! You have signed up successfully.'
    end

    it 'is logged in' do
      page.should have_content 'Sign out'
    end
  end

  describe 'with no password' do

    before do
      fill_in 'Email', with: 'alice@example.com'
      click_button 'Sign up'
    end

    it 'shows the missing password message' do
      page.should have_content 'password can\'t be blank'
    end
  end

  describe 'with existing email' do

    before do
      fill_in 'Email',    with: 'alice@example.com'
      fill_in 'Password', with: 'alice'
      click_button 'Sign up'
      click_link 'Sign out'
    end

    before do
      visit '/users/sign_up'
      fill_in 'Email',    with: 'alice@example.com'
      fill_in 'Password', with: 'alice'
      click_button 'Sign up'
    end

    it 'shows the already registerd accont message' do
      page.has_content? 'Email is already taken'
    end
  end
end


describe '/users/edit' do

  let!(:user) { FactoryGirl.create(:user) }

  before do
    visit '/users/sign_in'
    fill_in 'Email',    with: 'alice@example.com'
    fill_in 'Password', with: 'alice'
    click_button 'Sign in'
  end

  before do
    click_link 'Edit profile'
  end

  it 'shows the priofile page' do
    page.has_content? 'Edit profile'
  end

  describe 'when updating the profile' do

    before do
      fill_in 'Email', with: 'bob@example.com'
      click_button 'Update'
    end

    it 'shows the priofile page' do
      page.has_content? 'Edit user profile'
    end

    it 'updates the profile' do
      page.has_field? 'Email', with: 'bob@example.com'
    end
  end
end


describe '/users/cancel' do

  let!(:user) { FactoryGirl.create(:user) }

  before do
    visit '/users/sign_in'
    fill_in 'Email',    with: 'alice@example.com'
    fill_in 'Password', with: 'alice'
    click_button 'Sign in'
    click_link 'Edit profile'
  end

  it 'shows the profile page' do
    page.has_content? 'Edit profile'
  end

  describe 'when clicks on the cancel link' do

    before do
      click_link 'Cancel my account'
    end

    it 'deletes the account' do
      page.has_content? 'Your account was successfully cancelled.'
    end

    it 'shows the home page' do
      current_path.should == root_path
    end
  end
end


describe '/users/edit/password' do

  let!(:user) { FactoryGirl.create(:user) }

  before do
    visit '/users/sign_in'
    fill_in 'Email',    with: 'alice@example.com'
    fill_in 'Password', with: 'alice'
    click_button 'Sign in'
    click_link 'Edit profile'
  end

  before do
    click_link 'Edit my password'
  end

  it 'shows the priofile page' do
    page.has_content? 'Edit password'
  end

  describe 'when user set the new password' do

    before do
      fill_in 'Password',              with: 'bob'
      fill_in 'Password confirmation', with: 'bob'
      fill_in 'Current password',      with: 'alice'
      click_button 'Update'
    end

    it 'changes the password' do
      page.has_content? 'You updated your account successfully.'
    end

    describe 'when sign out' do

      before do
        click_link 'Sign out'
      end

      describe 'sign in with the new password' do

        before do
          visit '/users/sign_in'
          fill_in 'Email',    with: 'alice@example.com'
          fill_in 'Password', with: 'bob'
          click_button 'Sign in'
        end

        it 'signs in' do
          page.should have_content('Signed in successfully.')
        end
      end
    end
  end
end
