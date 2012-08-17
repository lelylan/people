require File.expand_path(File.dirname(__FILE__) + '/../acceptance_helper')

feature 'refresh token' do

  let!(:application) { FactoryGirl.create :application }
  let!(:devices)     { [ Moped::BSON::ObjectId('000aa0a0a000a00000000001') ] }
  let!(:token)       { FactoryGirl.create :access_token, application: application, devices: devices, use_refresh_token: true  }
  let!(:user)        { FactoryGirl.create :user }

  describe 'when sends an authorization request' do

    before do
      page.driver.browser.authorize application.uid, application.secret
      page.driver.post '/oauth/token', authorization_params
    end

    it 'returns valid json' do
      expect { JSON.parse(page.source) }.to_not raise_error
    end

    describe 'when returns the acces token representation' do

      let(:token)     { Doorkeeper::AccessToken.last }
      subject(:json)  { Hashie::Mash.new JSON.parse(page.source) }

      its(:access_token)  { should == token.token }
      its(:expires_in)    { should == 7200 }
      its(:token_type)    { should == 'bearer' }
      its(:refresh_token) { should == token.refresh_token }
    end
  end
  let!(:authorization_params) {{
    grant_type: 'refresh_token',
    refresh_token: token.refresh_token
  }}

  describe 'when sends a refresh token request' do

    before do
      page.driver.browser.authorize application.uid, application.secret
      page.driver.post '/oauth/token', authorization_params
    end

    it 'returns valid json' do
      expect { JSON.parse(page.source) }.to_not raise_error
    end

    describe 'when returns the acces token representation' do

      let(:new_token) { Doorkeeper::AccessToken.last }
      subject(:json)  { Hashie::Mash.new JSON.parse(page.source) }

      it 'is a new token' do
        new_token.id.should_not == token.id
      end

      it 'has a new refresh token' do
        new_token.refresh_token.should_not == token.refresh_token
      end

      it 'has the resources for advanced scope' do
        new_token.devices.should == token.devices
      end
    end
  end
end
