class Device
  include Mongoid::Document
  set_database :devices

  field :name
end
