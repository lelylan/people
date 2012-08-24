# Filterable Token
#
# Limits the accessible resources for a specific token.

module Filterable
  extend ActiveSupport::Concern

  included do
    embeds_many :resources, class_name: 'FilteredResource', cascade_callbacks: true, inverse_of: :token
  end

  def device_ids
    filtered_ids 'device'
  end

  def location_ids
    filtered_ids 'location'
  end

  private

  def filtered_ids(type)
    resources.where(filtered_type: type).map(&:filtered_ids).flatten.uniq
  end
end
