require File.expand_path(File.dirname(__FILE__) + '/../acceptance_helper')

describe '/me' do

  describe 'with not valid token' do

    before { visit '/me' }

    it 'returns a 401 response' do
      page.status_code.should == 401
    end

    it 'returns a 401 json representaion' do
      #pending
    end
  end

  describe 'when token is valid' do

    let!(:application) { FactoryGirl.create :application }
    let!(:user)        { FactoryGirl.create :user }
    let!(:token)       { FactoryGirl.create :access_token, application: application, resource_owner_id: user.id }

    before { visit '/me?access_token' + token.token }

    it 'returns a 200 response' do
      page.status_code.should == 200
    end
  end
end
