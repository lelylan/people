require 'spec_helper'

describe Doorkeeper::AccessGrant do

  it_behaves_like 'resourceable' do
    let(:model) { :access_grant }
  end
end
