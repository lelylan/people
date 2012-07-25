class Doorkeeper::AccessToken
  field :devices, type: Array, default: []

  attr_protected :devices
end
