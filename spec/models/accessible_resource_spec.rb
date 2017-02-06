require 'spec_helper'

describe AccessibleResource do

  it { should validate_presence_of :resource_id }

  it { %w(device).each    {|type| should allow_value(type).for(:resource_type)} }
  it { [nil, '', 'not_valid'].each {|type| should_not allow_value(type).for(:resource_type)} }

  it { %w(device).each    {|type| should allow_value(type).for(:accessible_type)} }
  it { [nil, '', 'not_valid'].each {|type| should_not allow_value(type).for(:accessible_type)} }
end
