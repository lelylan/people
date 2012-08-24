class FilteredResource
  include Mongoid::Document

  field :resource_id, type: Moped::BSON::ObjectId
  field :resource_type
  field :filtered_ids, type: Array, default: []
  field :filtered_type

  embedded_in :token

  validates :resource_id, presence: true
  validates :resource_type, presence: true, inclusion: { in: %w(device location) }
  validates :filtered_type, presence: true, inclusion: { in: %w(device location) }

  before_save :set_filtered_ids

  private

  def set_filtered_ids
    self.filtered_ids = selected_device   if resource_type == 'device'   and filtered_type == 'device'
    self.filtered_ids = contained_devices if resource_type == 'location' and filtered_type == 'device'
    self.filtered_ids = selected_location if resource_type == 'location' and filtered_type == 'location'
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
