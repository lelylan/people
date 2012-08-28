class AccessibleResource
  include Mongoid::Document

  field :resource_id, type: Moped::BSON::ObjectId  # id for the saved resource
  field :resource_type
  field :accessible_ids, type: Array, default: []    # ids
  field :accessible_type

  embedded_in :token

  validates :resource_id, presence: true
  validates :resource_type, presence: true, inclusion: { in: %w(device location) }
  validates :accessible_type, presence: true, inclusion: { in: %w(device location) }

  before_save :set_accessible_ids

  private

  def set_accessible_ids
    self.accessible_ids = selected_device   if resource_type == 'device'   and accessible_type == 'device'
    self.accessible_ids = contained_devices if resource_type == 'location' and accessible_type == 'device'
    self.accessible_ids = selected_location if resource_type == 'location' and accessible_type == 'location'
  end

  def selected_device
    [ resource_id ]
  end

  def selected_location
    Location.find(resource_id).descendants.map(&:id) << resource_id
  end

  def contained_devices
    Location.find(resource_id).contained_devices
  end
end
