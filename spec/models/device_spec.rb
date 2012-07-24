require 'spec_helper'

describe Device do

  let(:device) { Device.create(name: 'device') }

  it 'should connect to the device database' do
    Device.db.name.should match 'devices'
  end

  it 'creates simple devices' do
    device.name.should == 'device'
  end
end
