require 'spec_helper'

describe FilteredResource do

  it { should validate_presence_of :resource_id }

  it { %w(device location).each    {|type| should allow_value(type).for(:resource_type)} }
  it { [nil, '', 'not_valid'].each {|type| should_not allow_value(type).for(:resource_type)} }

  it { %w(device location).each    {|type| should allow_value(type).for(:filtered_type)} }
  it { [nil, '', 'not_valid'].each {|type| should_not allow_value(type).for(:filtered_type)} }
end
