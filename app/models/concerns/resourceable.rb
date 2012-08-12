# Resourceable
#
# Add resources to the model to enable advanced scope.
#
# Examples
#
#   resources = { resources: [devices: [...], locations: [...] }
#   @model.save_resources resources
#
# Return the updated model

module Resourceable
  extend ActiveSupport::Concern

  included do
    field :devices, type: Array, default: []
    attr_accessible :devices
  end

  def save_resources(resources)
    if filtered_resources? resources
      self.devices = extract(resources)
      self.save
    end
  end

  private

  def filtered_resources?(resources)
    !resources.nil? and (!resources[:devices].empty? or !resources[:locations].empty?)
  end

  def extract(resources)
    devices = extract_devices(resources) + extract_location_devices(resources)
    devices.uniq
  end

  def extract_devices(resources)
    resources[:devices]
  end

  def extract_location_devices(resources)
    list = Location.find(resources[:locations]).map(&:all_devices).flatten
  end
end
