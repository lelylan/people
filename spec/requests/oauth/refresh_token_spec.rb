require File.expand_path(File.dirname(__FILE__) + '/../acceptance_helper')

feature 'refresh token' do

  let!(:application)  { FactoryGirl.create :application }
  let!(:user)         { FactoryGirl.create :user }
  let!(:access_token) { FactoryGirl.create :access_token, :with_device, application: application, scopes: 'write', resource_owner_id: user.id, use_refresh_token: true }

  describe 'when token expires' do

    before { access_token.created_at = (Time.now - 10000); access_token.save }

    describe 'GET /me' do

      before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }
      before { page.driver.header 'Content-Type', 'application/json' }

      before  { page.driver.get '/me' }
      subject { page }

      its(:status_code) { should == 401 }
    end

    let!(:authorization_params) {{
      grant_type: 'refresh_token',
      refresh_token: access_token.refresh_token
    }}

    describe 'when sends a refresh token request' do

      before do
        page.driver.browser.authorize application.uid, application.secret
        page.driver.post '/oauth/token', authorization_params
      end

      it 'returns valid json' do
        expect { JSON.parse(page.source) }.to_not raise_error
      end

      it 'revokes expired token' do
        Doorkeeper::AccessToken.where(id: access_token.id).first.revoked_at.should_not == nil
      end


      describe 'when returns the acces token representation' do

        subject(:new_token) { Doorkeeper::AccessToken.last }

        its(:token)         { should_not == access_token.token }
        its(:refresh_token) { should_not == access_token.refresh_token }
        its(:device_ids)    { should == access_token.device_ids }
        its(:resources)     { should have(1).items }
      end
    end
  end
end
