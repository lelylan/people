class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Ancestry

  store_in session: 'locations'

  field :resource_owner_id, type: Moped::BSON::ObjectId
  field :name
  field :device_ids, type: Array, default: []

  has_ancestry orphan_strategy: :rootify

  def contained_devices
    (descendants.map(&:device_ids) + device_ids).flatten
  end
end
