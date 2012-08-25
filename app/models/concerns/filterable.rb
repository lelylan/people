# Filterable Token
#
# Limits the accessible resources for a specific token.

module Filterable
  extend ActiveSupport::Concern

  included do
    field :device_ids,   type: Array, default: []
    field :location_ids, type: Array, default: []
    attr_accessible :device_ids, :location_ids, :resources

    embeds_many :resources, class_name: 'FilteredResource', cascade_callbacks: true, inverse_of: :token
    before_save :set_device_ids, :set_location_ids
  end

  def set_device_ids
    self.device_ids = filtered_ids 'device'
  end

  def set_location_ids
    self.location_ids = filtered_ids 'location'
  end

  private

  def filtered_ids(type)
    resources.where(filtered_type: type).map(&:filtered_ids).flatten.uniq
  end
end
