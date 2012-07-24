require 'spec_helper'

describe Location do

  let(:house) { FactoryGirl.create :house, :with_descendants }

  it 'should connect to the location database' do
    Location.establish_connection.spec.config[:database].should match /locations/
  end

  describe '#devices' do
    it 'returns all house devices' do
      house.all_devices.should == [1, 2, 3, 4, 5, 6]
    end
  end
end
