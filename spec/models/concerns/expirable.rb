require 'spec_helper'

shared_examples_for 'expirable' do

  subject(:token) { FactoryGirl.create factory }
  before { token.update_attributes(expirable: '0') }

  its(:expirable) { should be_true }

  it 'sets the boolean value' do
    token.expirable.should be_false
  end
end
