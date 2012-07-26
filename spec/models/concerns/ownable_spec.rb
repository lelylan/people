require 'spec_helper'

shared_examples_for 'ownable' do

  let(:resource) { FactoryGirl.create model }

  it 'has field resource_owner_id' do
    resource.resource_owner_id.should_not be_nil
  end
end

describe 'ownable example' do

  before { cleanup }

  it_behaves_like 'ownable' do 

    let(:model) { :application }
  end
end
