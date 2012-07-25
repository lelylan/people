require 'spec_helper'

describe Doorkeeper::Application do

  let(:application) { FactoryGirl.create :application }

  it 'has field resource_owner_id' do
    application.resource_owner_id.should_not be_nil
  end
end
