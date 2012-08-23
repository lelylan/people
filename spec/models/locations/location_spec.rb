require 'spec_helper'

describe Location do

  let(:house) { FactoryGirl.create :house, :with_descendants }

  it 'connects to location database' do
    Location.database_name.should == 'locations_test'
  end

  it 'creates a location' do
    house.id.should_not be_nil
  end

  describe '#contained_devices' do

    let(:house_device) { house.device_ids.first }
    let(:floor_device) { house.descendants.first.device_ids.first }
    let(:room_device)  { house.descendants.last.device_ids.first }

    it 'contains house devices' do
      house.contained_devices.should include house_device
    end

    it 'contains house devices' do
      house.contained_devices.should include floor_device
    end

    it 'contains house devices' do
      house.contained_devices.should include room_device
    end
  end
end
