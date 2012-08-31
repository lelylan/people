# Enable a token to be expirable or not through a checkbok and not a global setting.

module Expirable
  extend ActiveSupport::Concern

  included do
    field :expirable, type: Boolean, default: true
    attr_accessible :expirable
  end
end
