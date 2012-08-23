class Device
  include Mongoid::Document

  store_in session: 'devices'

  field :name
  field :resource_owner_id, type: Moped::BSON::ObjectId
end
