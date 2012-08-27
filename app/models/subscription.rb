class Subscription
  include Mongoid::Document

  field :email
  field :description

  validates :email, presence: true, uniqueness: true, email: true
end
