require 'spec_helper'

shared_examples_for 'accessible' do

  describe 'when filters a device by selecting a device' do

    let(:token)  { FactoryGirl.create factory, :with_device }
    let(:device) { Device.find(token.resources.first.resource_id) }

    it 'filters the selected device' do
      token.device_ids.should == [device.id]
    end
  end

end
