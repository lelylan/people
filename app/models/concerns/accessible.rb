# Limits the accessible resources for a specific token.

module Accessible
  extend ActiveSupport::Concern

  included do
    field :device_ids,   type: Array,   default: []

    attr_accessible :device_ids, :resources

    index({ device_ids: 1 })

    embeds_many :resources, class_name: 'AccessibleResource', cascade_callbacks: true, inverse_of: :token
    before_save :set_device_ids
  end

  def set_device_ids
    self.device_ids = accessible_ids 'device'
  end

  private

  def accessible_ids(type)
    resources.where(accessible_type: type).map(&:accessible_ids).flatten.uniq
  end
end
