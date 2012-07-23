require File.expand_path(File.dirname(__FILE__) + '/../acceptance_helper')

describe 'GET /me' do

  describe 'with not valid token' do

    before { visit '/me' }

    it 'returns 401 status code' do
      page.status_code.should == 401
    end

    it 'returns valid json' do
      #pending
    end

    it 'returns 401 json representation' do
      #pending
    end
  end

  describe 'when token is valid' do

    let!(:application) { FactoryGirl.create :application }
    let!(:user)        { FactoryGirl.create :user, :with_all_attributes }
    let!(:token)       { FactoryGirl.create :access_token, application: application, resource_owner_id: user.id }

    before { visit "/me?access_token=#{token.token}" }

    it 'returns 200 status code' do
      page.status_code.should == 200
    end

    it 'returns Content-Type as application/json' do
      page.response_headers['Content-Type'].should match 'application/json'
    end

    it 'returns valid json' do
      expect { JSON.parse(page.source) }.to_not raise_error
    end

    describe 'user representation' do

      subject(:json) { Hashie::Mash.new JSON.parse(page.source) }

      its(:email)     { should == 'alice@example.com' }
      its(:username)  { should == 'alice' }
      its(:full_name) { should == 'Alice Bella' }
      its(:location)  { should == 'Fantasia' }
      its(:homepage)  { should == 'http://example.com' }
    end
  end
end
