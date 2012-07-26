require 'spec_helper'

describe Doorkeeper::Application do

  it_behaves_like 'ownable' do 
    let(:model) { :application }
  end
end
