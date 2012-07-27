require 'spec_helper'

describe Doorkeeper::AccessToken do

  it_behaves_like 'resourceable' do
    let(:model) { :access_token }
  end
end
