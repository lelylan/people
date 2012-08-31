require 'spec_helper'

describe Doorkeeper::AccessToken do

  it_behaves_like 'accessible' do
    let(:factory) { :access_grant }
  end
end
