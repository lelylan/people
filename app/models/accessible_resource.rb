class AccessibleResource
  include Mongoid::Document

  field :resource_id, type: Moped::BSON::ObjectId  # id for the saved resource
  field :resource_type
  field :accessible_ids, type: Array, default: []  # ids
  field :accessible_type

  embedded_in :token

  validates :resource_id, presence: true
  validates :resource_type, presence: true, inclusion: { in: %w(device) }
  validates :accessible_type, presence: true, inclusion: { in: %w(device) }

  before_save :set_accessible_ids

  private

  def set_accessible_ids
    self.accessible_ids = selected_device   if resource_type == 'device'   and accessible_type == 'device'
  end

  def selected_device
    [ resource_id ]
  end

end
