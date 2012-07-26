require 'spec_helper'

describe Doorkeeper::Application do

  before { cleanup }

  it_behaves_like 'ownable' do 

    let(:model) { :application }
  end
end
