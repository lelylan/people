require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'authorization' do

  describe '/users/signin' do

    let!(:user) { FactoryGirl.create(:user) }

    before do
      visit '/'
      click_link 'Sign in'
    end

    it 'shows the sign in page' do
      page.should have_content 'Sign in'
    end

    describe 'with valid email and password' do

      before do
        fill_in 'Email',    with: 'alice@example.com'
        fill_in 'Password', with: 'password'
        click_button 'Sign in'
      end

      it 'signs in' do
        page.should have_content('Signed in successfully.')
      end
    end

    describe 'with not valid email' do

      before do
        fill_in 'Email',    with: 'invalid@example.com'
        fill_in 'Password', with: 'password'
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
      fill_in 'Password', with: 'password'
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
    include EmailSpec::Helpers
    include EmailSpec::Matchers

    let!(:user) { FactoryGirl.create(:user) }

    before do
      visit '/'
      click_link 'Forgot your password?'
    end

    it 'shows the forgot your password page' do
      page.should have_content('Forgot your password?')
    end

    describe 'when user exists' do

      before do
        fill_in 'Email', with: 'alice@example.com'
        click_button 'Send me reset password instructions'
      end

      it 'sends the mail for password recovery' do 
        page.should have_content 'You will receive an email with instructions'
      end

      describe 'when checking the mail' do

        it 'sends the mail' do
          last_email.should_not be_nil
        end

        it 'sends the mail to the filled mail address' do
          last_email.to.should include 'alice@example.com'
        end

        describe 'when clicking to #reset_password_token' do

          before do
            visit '/users/password/edit?reset_password_token=' + reset_password_token(last_email)
          end

          it 'shows the change password page' do
            page.should have_content('Change your password')
          end

          describe 'when fills in the new password' do

            before do
              fill_in 'New password',         with: 'reset_password'
              fill_in 'Confirm new password', with: 'reset_password'
              click_button 'Change my password'
            end

            it 'changes the password' do
              page.should have_content('Your password was changed successfully.')
            end
          end
        end
      end
    end

    describe 'when user does not exists' do

      before do
        fill_in 'Email', with: 'invalid@example.com'
        click_button 'Send me reset password instructions'
      end

      it 'send the mail for password recovery' do 
        page.should have_content('Email not found')
      end
    end
  end


  describe '/users/sign_up' do

    before do
      visit '/'
      click_link 'Sign up'
    end

    it 'shows the sign up page' do
      page.should have_content('Sign up')
    end

    describe 'with all fields filled in' do

      before do
        fill_in 'Email',    with: 'alice@example.com'
        fill_in 'Password', with: 'password'
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
        fill_in 'Password', with: 'password'
        click_button 'Sign up'
        click_link 'Sign out'
      end

      before do
        visit '/users/sign_up'
        fill_in 'Email',    with: 'alice@example.com'
        fill_in 'Password', with: 'password'
        click_button 'Sign up'
      end

      it 'shows the already registerd accont message' do
        page.should have_content 'Email is already taken'
      end
    end
  end


  describe '/users/edit' do

    let!(:user) { FactoryGirl.create(:user) }

    before do
      visit '/users/sign_in'
      fill_in 'Email',    with: 'alice@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
    end

    before do
      click_link 'Edit profile'
    end

    it 'shows the priofile page' do
      page.should have_content 'Edit profile'
    end

    describe 'when updating the profile' do

      before do
        fill_in 'Email',     with: 'bob@example.com'
        fill_in 'Full name', with: 'Bob'
        fill_in 'Homepage',  with: 'www.example.com'
        click_button 'Update'
      end

      it 'shows the profile page' do
        page.should have_content 'User profile'
      end

      it 'updates the profile' do
        page.should_not have_content 'error'
      end

      it 'updates the fields' do
        find_field('Email').value.should     == 'bob@example.com'
        find_field('Full name').value.should == 'Bob'
        find_field('Homepage').value.should  == 'www.example.com'
      end
    end
  end


  describe '/users/cancel' do

    let!(:user) { FactoryGirl.create(:user) }

    before do
      visit '/users/sign_in'
      fill_in 'Email',    with: 'alice@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      click_link 'Edit profile'
    end

    it 'shows the profile page' do
      page.should have_content 'Edit profile'
    end

    describe 'when clicks on the cancel link' do

      before do
        click_link 'Cancel my account'
      end

      it 'deletes the account' do
        page.should have_content 'Your account was successfully cancelled.'
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
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      click_link 'Edit profile'
    end

    before do
      click_link 'Edit my password'
    end

    it 'shows the priofile page' do
      page.should have_content 'Edit password'
    end

    describe 'when user set the new password' do

      before do
        fill_in 'Password',              with: 'new_password'
        fill_in 'Password confirmation', with: 'new_password'
        fill_in 'Current password',      with: 'password'
        click_button 'Update'
      end

      it 'shows the profile page' do
        page.should have_content 'User profile'
      end

      it 'changes the password' do
        page.should have_content 'You updated your account successfully.'
      end

      describe 'when sign out' do

        before do
          click_link 'Sign out'
        end

        describe 'sign in with the new password' do

          before do
            visit '/users/sign_in'
            fill_in 'Email',    with: 'alice@example.com'
            fill_in 'Password', with: 'new_password'
            click_button 'Sign in'
          end

          it 'signs in' do
            page.should have_content 'Signed in successfully.'
          end
        end
      end
    end
  end
end
