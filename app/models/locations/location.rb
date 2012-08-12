class Location < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  acts_as_nested_set

  serialize :devices, Array

  def all_devices
    self_and_descendants.map(&:devices).flatten
  end
end
