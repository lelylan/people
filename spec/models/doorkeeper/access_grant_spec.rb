require 'spec_helper'

describe Doorkeeper::AccessGrant do

  before { cleanup }

  it_behaves_like 'resourceable' do
    let(:model) { :access_grant }
  end
end
