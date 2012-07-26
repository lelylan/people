require 'spec_helper'

describe Doorkeeper::AccessToken do

  before { cleanup }

  it_behaves_like 'resourceable' do

    let(:model) { :access_token }
  end
end
