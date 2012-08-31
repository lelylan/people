class Subscription
  include Mongoid::Document

  field :email
  field :description

  index({ email: 1 })

  validates :email, presence: true, uniqueness: true, email: true
end
