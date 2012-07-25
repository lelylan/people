require 'spec_helper'

describe User do

  before { cleanup }

  describe 'when validates presence of email' do

    it 'shows an presence error' do
      expect { FactoryGirl.create :user, email: ''}.to raise_error Mongoid::Errors::Validations
    end
  end

  describe 'when validates uniqueness of email' do

    let!(:user) { FactoryGirl.create :user }

    it 'shows an error' do
      expect { FactoryGirl.create :user, username: 'another' }.to raise_error Mongoid::Errors::Validations
    end
  end

  describe 'when validates lenght of' do

    it 'shows an error' do
      expect { FactoryGirl.create :user, password: '1234567' }.to raise_error Mongoid::Errors::Validations
    end

    it 'shows a presence error' do
      expect { FactoryGirl.create :user, password: '12345678' }.to_not raise_error Mongoid::Errors::Validations
    end
  end

  describe 'when validates uniqueness of name' do

    let!(:user) { FactoryGirl.create :user }

    it 'shows an error' do
      expect { FactoryGirl.create :user, email: 'another' }.to raise_error Mongoid::Errors::Validations
    end
  end

  describe '#save_resources' do

    let!(:user) { FactoryGirl.create :user }

    describe 'with nil resources' do

      before { user.save_resources(nil) }

      it 'sets devices with an empty array' do
        user.devices.should == []
      end
    end

    describe 'with empty resources' do

      let(:resources) do
        { devices: [], locations: [] }
      end

      before { user.save_resources(resources) }

      it 'sets devices with an empty array' do
        user.devices.should == []
      end
    end

    describe 'with locations' do

      let(:house)     { FactoryGirl.create :house, :with_descendants }
      let(:device_id) { BSON::ObjectId('500fb2d4d033a95185000007') }
      let(:summer)    { FactoryGirl.create :house, name: 'Summer house', devices: [ device_id ] }
      let(:locations) { [ house.id, summer.id ] }
      let(:resources) { { devices: [], locations: locations } }

      before { user.save_resources(resources) }

      describe 'when sets devices with the list of devices in the houses' do

        let(:devices) { house.all_devices + summer.all_devices }

        it 'sets the house devices' do
          user.devices.should == devices
        end
      end
    end

    describe 'with list of devices' do

      let(:light)     { FactoryGirl.create :light  }
      let(:dimmer)    { FactoryGirl.create :device, name: 'Dimmer' }
      let(:other)     { FactoryGirl.create :device, name: 'Other' }
      let(:devices)   { [ light.id, dimmer.id ] }
      let(:resources) { { devices: devices, locations: [] } }

      before { user.save_resources(resources) }

      it 'sets devices with the list of devices' do
        user.devices.should == devices
      end

      describe 'with locations' do

        let(:house)     { FactoryGirl.create :house, :with_descendants }
        let(:locations) { [ house.id ] }
        let(:resources) { { devices: devices, locations: locations } }
        let(:list)      { devices + house.all_devices }

        before { user.save_resources(resources) }

        it 'sets device with all devices' do
          user.devices.should == list
        end

        describe 'with common devices' do

          let(:summer) { FactoryGirl.create :house, name: 'Summer house', devices: [ light.id ] }
          let(:locations) { [ house.id, summer.id ] }

          before { user.save_resources(resources) }

          it 'sets device with all devices once' do
            user.devices.should == list
          end
        end
      end
    end
  end
end
