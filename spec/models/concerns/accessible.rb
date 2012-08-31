require 'spec_helper'

shared_examples_for 'accessible' do

  describe 'when filters a device by selecting a device' do

    let(:token)  { FactoryGirl.create factory, :with_device }
    let(:device) { Device.find(token.resources.first.resource_id) }

    it 'filters the selected device' do
      token.device_ids.should == [device.id]
    end
  end

  describe 'when filters devices contained in a location' do

    let(:token) { FactoryGirl.create :access_token, :with_contained_devices }

    let(:house)        { Location.find(token.resources.first.resource_id) }
    let(:house_device) { house.device_ids.first }
    let(:floor_device) { house.descendants.first.device_ids.first }
    let(:room_device)  { house.descendants.last.device_ids.first }

    it 'filters all devices contained in the house' do
      token.device_ids.should have(3).items
    end

    it 'filters the house device' do
      token.device_ids.should include house_device
    end

    it 'filters the floor device' do
      token.device_ids.should include floor_device
    end

    it 'filters the room device' do
      token.device_ids.should include room_device
    end
  end

  describe 'when filters a location by selecting a location' do

    let(:token)    { FactoryGirl.create factory, :with_location }
    let(:location) { Location.find(token.resources.first.resource_id) }

    it 'filters the selected device' do
      token.location_ids.should == [location.id]
    end
  end

  describe 'when filters locations contained in a location' do

    let(:token) { FactoryGirl.create :access_token, :with_contained_locations }

    let(:house) { Location.find(token.resources.first.resource_id) }
    let(:floor) { house.descendants.first }
    let(:room)  { house.descendants.last }

    it 'filters all devices contained in the house' do
      token.location_ids.should have(3).items
    end

    it 'filters the house device' do
      token.location_ids.should include house.id
    end

    it 'filters the floor device' do
      token.location_ids.should include floor.id
    end

    it 'filters the room device' do
      token.location_ids.should include room.id
    end
  end
end
