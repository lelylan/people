require 'spec_helper'

describe Location do

  let(:house) { FactoryGirl.create :house, :with_descendants }

  it 'should connect to the location database' do
    Location.establish_connection.spec.config[:database].should match /locations/
  end

  describe '#devices' do
    it 'returns all house devices' do
      base = '500fb2d4d033a9518500000'
      house.all_devices.should == ["#{base}1", "#{base}2", "#{base}3", "#{base}4", "#{base}5", "#{base}6"]
    end
  end
end
