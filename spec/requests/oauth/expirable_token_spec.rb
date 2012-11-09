require File.expand_path(File.dirname(__FILE__) + '/../acceptance_helper')

feature 'authorization code flow' do

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }

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

        describe 'when makes the token not expirable' do

          before { uncheck 'expirable' }

          describe 'when authorizes the client' do

            before { begin page.click_button 'Authorize' rescue ActionController::RoutingError end }

            let(:redirect_uri) { page.current_host + page.current_path }

            let!(:authorization_code) do
              query = URI.parse(page.current_url).query
              Rack::Utils.parse_nested_query(query)['code']
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

              describe 'the token does not expires' do

                let(:token)     { Doorkeeper::AccessToken.last }
                subject(:json)  { Hashie::Mash.new JSON.parse(page.source) }

                its(:expires_in) { should == nil }
              end
            end
          end
        end
      end
    end
  end
end

feature 'implicit grant flow' do

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }

  let!(:authorization_params) do
    { response_type: 'token',
      client_id:     application.uid,
      redirect_uri:  application.redirect_uri,
      scope:         'resources',
      state:         'remember-me' }
  end

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

        describe 'when makes the token not expirable' do

          before { uncheck 'expirable' }

          describe 'when authorizes the client', js: true do

            before { page.click_button 'Authorize' }

            let(:redirect_uri) { page.current_host + page.current_path }

            describe 'when returns the acces token representation' do

              subject(:fragment) do
                params = URI.parse(page.current_url).fragment
                Hashie::Mash.new Rack::Utils.parse_nested_query(params)
              end

              its(:expires_in) { should == nil }
            end
          end
        end
      end
    end
  end
end
