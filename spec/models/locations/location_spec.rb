require 'spec_helper'

describe Location do

  let(:house) { FactoryGirl.create :house, :with_descendants }

  it 'should connect to the location database' do
    Location.establish_connection.spec.config[:database].should match /locations/
  end

  describe '#devices' do

    let(:house_device) { Moped::BSON::ObjectId('000aa0a0a000a00000000001') }
    let(:floor_device) { Moped::BSON::ObjectId('000aa0a0a000a00000000002') }
    let(:room_device)  { Moped::BSON::ObjectId('000aa0a0a000a00000000003') }

    it 'returns all house devices' do
      house.all_devices.should == [house_device, floor_device, room_device]
    end
  end
end
