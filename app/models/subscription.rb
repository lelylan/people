class Subscription
  include Mongoid::Document

  field :email
  field :description
  field :later, type: Boolean, default: false

  index({ email: 1 })

  validates :email, presence: true, uniqueness: true, email: true
end
