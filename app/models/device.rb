class Device
  include Mongoid::Document
  set_database :devices

  field :name
  field :resource_owner_id
end
