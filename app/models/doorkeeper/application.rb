class Doorkeeper::Application
  field :resource_owner_id, type: Integer

  attr_protected :resource_owner_id
  validates      :resource_owner_id, presence: true
end
