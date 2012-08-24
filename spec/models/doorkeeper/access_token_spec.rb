require 'spec_helper'

describe Doorkeeper::AccessToken do

  it_behaves_like 'filterable' do
    let(:factory) { :access_token }
  end
end
