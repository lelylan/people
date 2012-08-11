require 'spec_helper'

describe Device do

  let(:device) { FactoryGirl.create :device }

  it 'connects to the device database' do
    Device.database_name.should == 'devices_test'
  end

  it 'creates simple devices' do
    device.name.should == 'light'
  end
end
