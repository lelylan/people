class Doorkeeper::Application
  field     :resource_owner_id, type: Integer
  validates :resource_owner_id, presence: true
end
