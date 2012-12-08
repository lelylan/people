require 'spec_helper'

describe User do

  its(:admin) { should == false }
  its(:rate_limit) { should == 5000 }

  describe 'when validates presence of email' do

    it 'shows a presence error' do
      expect { FactoryGirl.create :user, email: ''}.to raise_error Mongoid::Errors::Validations
    end
  end

  describe 'when validates uniqueness of email' do

    let!(:user) { FactoryGirl.create :user }

    it 'shows an error' do
      expect { FactoryGirl.create :user, username: 'another' }.to raise_error Mongoid::Errors::Validations
    end
  end

  describe 'when validates lenght of' do

    it 'shows an error' do
      expect { FactoryGirl.create :user, password: '1234567' }.to raise_error Mongoid::Errors::Validations
    end

    it 'shows a presence error' do
      expect { FactoryGirl.create :user, password: '12345678' }.to_not raise_error Mongoid::Errors::Validations
    end
  end

  describe 'when validates uniqueness of name' do

    let!(:user) { FactoryGirl.create :user }

    it 'shows an error' do
      expect { FactoryGirl.create :user, email: 'another' }.to raise_error Mongoid::Errors::Validations
    end
  end
end
