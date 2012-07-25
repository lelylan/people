require 'spec_helper'

describe Device do

  let(:device) { FactoryGirl.create :device }

  it 'should connect to the device database' do
    Device.db.name.should match 'devices'
  end

  it 'creates simple devices' do
    device.name.should == 'light'
  end
end
