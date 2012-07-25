require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'authorization code flow' do

  before { cleanup }

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }
  let!(:light)       { FactoryGirl.create :light, resource_owner_id: user.id  }
  let!(:house)       { FactoryGirl.create :house, :with_descendants, resource_owner_id: user.id.to_s }

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

      describe 'when signs in' do

        before do
          fill_in 'Email',    with: 'alice@example.com'
          fill_in 'Password', with: 'password'
          click_button 'Sign in'
        end

        describe 'when click on filter resources' do

          before { click_link 'Filter resources' }

          describe 'when adds resources' do

            before { within('.devices')   { click_link 'Add' } }
            before { within('.locations') { click_link 'Add' } }

            describe 'when authorizes the client' do

              let(:devices)   { [ light.id ] }
              let(:locations) { house.all_devices }
              let(:resources) { devices + locations }

              before { click_link 'Back to authorization' }
              before { begin page.click_button 'Authorize' rescue ActionController::RoutingError end }

              describe 'when checking the grant access' do

                let(:grant) { Doorkeeper::AccessGrant.last }

                it 'contains all devices' do
                  grant.devices.should == resources
                end
              end
            end
          end
        end
      end
    end
  end
end
