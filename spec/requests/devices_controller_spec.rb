require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'when filters a device by selecting a device' do

  let!(:user)        { FactoryGirl.create :user }
  let!(:application) { FactoryGirl.create :application }
  let!(:device)      { FactoryGirl.create :device, resource_owner_id: user.id }

  let!(:authorization_params) {{
    response_type: 'code',
    client_id:     application.uid,
    redirect_uri:  application.redirect_uri,
    scope:         'resources',
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

          before { click_link 'Filter Accessible Devices' }

          it 'shows the filterable devices' do
            page.should have_content device.name
          end

          describe 'when adds a device' do

            before do
              within('.devices') { click_link 'Add' }
            end

            it 'shows a message' do
              page.should have_content 'One or more devices has been added'
            end

            it 'hides the add link' do
              within('.devices') { page.should_not have_link 'Add' }
            end

            it 'shows the remove link' do
              within('.devices') { page.should have_link 'Remove'}
            end

            describe 'when removes the device' do

              before do
                within('.devices') { click_link 'Remove' }
              end

              it 'shows a message' do
                page.should have_content 'One or more devices has been removed'
              end

              it 'hides the add link' do
                within('.devices') { page.should have_link 'Add' }
              end

              it 'shows the remove link' do
                within('.devices') { page.should_not have_link 'Remove'}
              end

              shared_examples 'click back to the authorization page' do

                before { click_link 'Back to authorization' }

                it 'shows the authorization page' do
                  page.should have_content 'Authorization for'
                end
              end

              it_behaves_like 'click back to the authorization page'
            end

            it_behaves_like 'click back to the authorization page'
          end

          describe 'when adds a not owned device' do

            let!(:bob)         { FactoryGirl.create :bob }
            let!(:bob_device)  { FactoryGirl.create :device, resource_owner_id: bob.id }
            let(:resource_uri) { "/oauth/authorize/#{bob_device.id}?type=devices" }

            it 'shows a not found page' do
              expect { page.driver.put resource_uri }.to raise_error
            end
          end

          describe 'when clicks back to the authorization page' do

            before { click_link 'Back to authorization' }

            it 'shows the authorization page' do
              page.should have_content 'Authorization for'
            end
          end
        end
      end
    end
  end
end

feature 'when filters devices contained in a location' do

  let!(:user)        { FactoryGirl.create :user }
  let!(:application) { FactoryGirl.create :application }
  let!(:device)      { FactoryGirl.create :device, resource_owner_id: user.id }
  let!(:location)    { FactoryGirl.create :location, :with_descendants, resource_owner_id: user.id.to_s }

  let!(:authorization_params) {{
    response_type: 'code',
    client_id:     application.uid,
    redirect_uri:  application.redirect_uri,
    scope:         'resources',
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

          before { click_link 'Filter Accessible Devices' }

          it 'shows the filterable locations' do
            page.should have_content location.name
          end

          describe 'when adds a location' do

            before do
              within('.locations') { click_link 'Add' }
            end

            it 'shows a message' do
              page.should have_content 'One or more devices has been added'
            end

            it 'hides the add link' do
              within('.locations') { page.should_not have_link 'Add' }
            end

            it 'shows the remove link' do
              within('.locations') { page.should have_link 'Remove'}
            end

            describe 'when removes the location' do

              before do
                within('.locations') { click_link 'Remove' }
              end

              it 'shows a message' do
                page.should have_content 'One or more devices has been removed'
              end

              it 'hides the add link' do
                within('.locations') { page.should have_link 'Add' }
              end

              it 'shows the remove link' do
                within('.locations') { page.should_not have_link 'Remove'}
              end

              it_behaves_like 'click back to the authorization page'
            end

            it_behaves_like 'click back to the authorization page'
          end

          describe 'when adds a not owned location' do

            let!(:bob)          { FactoryGirl.create :bob }
            let!(:bob_location) { FactoryGirl.create :location, resource_owner_id: bob.id }
            let(:resource_uri)  { "/oauth/authorize/#{bob_location.id}?type=locations" }

            it 'shows a not found page' do
              expect { page.driver.put resource_uri }.to raise_error
            end
          end

          describe 'when clicks back to the authorization page' do

            before { click_link 'Back to authorization' }

            it 'shows the authorization page' do
              page.should have_content 'Authorization for'
            end
          end
        end
      end
    end
  end
end
