require File.expand_path(File.dirname(__FILE__) + '/../acceptance_helper')

feature 'authorization code flow with accessible devices' do

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }
  let!(:light)       { FactoryGirl.create :light, resource_owner_id: user.id  }
  let!(:house)       { FactoryGirl.create :house, :with_descendants, resource_owner_id: user.id }

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

      describe 'when signs in' do

        before do
          fill_in 'Email',    with: 'alice@example.com'
          fill_in 'Password', with: 'password'
          click_button 'Sign in'
        end

        describe 'when clicks on filter resources' do

          before { click_link 'Filter Accessible Devices' }

          describe 'when adds a device and a location containing devices' do

            before { within('.devices')   { click_link 'Add' } }
            before { within('.locations') { click_link 'Add' } }

            describe 'when authorizes the client' do

              before { click_link 'Back to authorization'; }
              before { begin page.click_button 'Authorize' rescue ActionController::RoutingError end }

              let(:redirect_uri) { page.current_host + page.current_path }

              let!(:authorization_code) do
                query = URI.parse(page.current_url).query
                Rack::Utils.parse_nested_query(query)['code']
              end

              it 'redirects to the client callback uri' do
                redirect_uri.should == application.redirect_uri
              end

              it 'returns an activation code' do
                authorization_code.should_not be_nil
              end

              describe 'when sends an access token request' do

                let!(:access_params) do
                  { grant_type:  'authorization_code',
                    code:         authorization_code,
                    redirect_uri: application.redirect_uri }
                end

                before do
                  page.driver.browser.authorize application.uid, application.secret
                  page.driver.post '/oauth/token', access_params
                end

                describe 'when returns the acces token representation' do

                  subject(:json)     { Hashie::Mash.new JSON.parse(page.source) }
                  its(:access_token) { should == Doorkeeper::AccessToken.last.token }
                end

                describe 'when returns the accessible access token' do

                  subject          { Doorkeeper::AccessToken.last }
                  let(:device_ids) { ([light.id] << house.contained_devices).flatten }

                  its(:device_ids) { should have(4).items }
                  its(:device_ids) { subject.should == device_ids }
                end
              end
            end
          end
        end
      end
    end
  end
end

# NOTE: this is an incomplete test as we do not check the token in the hash.
# Actually the problem is due to the fact that when we click to the buttons
# to add the devices, the button is found, but nothing is made. Maybe new
# versions of capybara will solve the problem. In that case take the implicit
# grant flow and remake this part js based with the check of the token.

#feature 'implicit grant flow with accessible devices' do

  #let!(:application) { FactoryGirl.create :application }
  #let!(:user)        { FactoryGirl.create :user }
  #let!(:light)       { FactoryGirl.create :light, resource_owner_id: user.id  }
  #let!(:house)       { FactoryGirl.create :house, :with_descendants, resource_owner_id: user.id }

  #let!(:authorization_params) {{
    #response_type: 'token',
    #client_id:     application.uid,
    #redirect_uri:  application.redirect_uri,
    #scope:         'resources',
    #state:         'remember-me'
  #}}

  #describe 'when sends an authorization request' do

    #let(:uri) { "/oauth/authorize?#{authorization_params.to_param}" }
    #before    { visit uri }

    #describe 'when not logged in' do

      #describe 'when signs in' do

        #before do
          #fill_in 'Email',    with: 'alice@example.com'
          #fill_in 'Password', with: 'password'
          #click_button 'Sign in'
        #end

        #describe 'when clicks on filter resources' do

          #before { click_link 'Filter Accessible Devices' }

          #describe 'when adds a device and a location containing devices' do

            #before { within('.devices')   { click_link 'Add' } }
            #before { within('.locations') { click_link 'Add' } }

            #describe 'when authorizes the client' do

              #describe 'when authorizes the client' do

                #before { click_link 'Back to authorization' }
                #before { begin page.click_button 'Authorize' rescue ActionController::RoutingError end }

                #describe 'when returns the filtered access token' do

                  #subject          { Doorkeeper::AccessToken.last }
                  #let(:device_ids) { ([light.id] << house.contained_devices).flatten }

                  #its(:device_ids) { should have(4).items }
                  #its(:device_ids) { subject.should == device_ids }
                #end
              #end
            #end
          #end
        #end
      #end
    #end
  #end
#end


