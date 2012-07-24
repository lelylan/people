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

        describe 'when click on filter resources' do

          before { click_link 'Filter resources' }

          it 'shows the filterable devices' do
            page.should have_content device.name
          end

          it 'shows the filterable locations' do
            page.should have_content location.name
          end

          describe 'when adds a device' do

            before do
              within('.devices') { click_link 'Add' }
            end

            it 'hides the add link' do
              print page.html
              within('.devices') { page.should_not have_link 'Add' }
            end

            it 'shows the remove link' do
              within('.devices') { page.should have_link 'Remove'}
            end

            describe 'when removes the device' do
            end

            describe 'when add the same device' do
            end
          end

          describe 'when adds a location' do

            describe 'when removes the location' do
            end

            describe 'when add the same location' do
            end
          end

          describe 'when adds a not owned device' do
          end

          describe 'when adds a not owned location' do
          end

          describe 'when clicks back to authorization' do
          end
        end
      end
    end
  end  
end
