class User
  include Mongoid::Document

  # OPEN_SIGNUP: remove invitable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  field :email,              :type => String, :default => ''
  field :encrypted_password, :type => String, :default => ''

  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :password, length: { minimum: 8, allow_nil: true }

  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  field :remember_created_at, :type => Time

  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  # OPEN_SIGNUP: remove the invitable fields
  ## Invitable
  field :invitation_token
  field :invitation_sent_at, type: Time
  field :invitation_accepted_at, type: Time
  field :invitation_limit, type: Integer
  field :invited_by_id, type: Moped::BSON::ObjectId

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  # Personalized fields
  field :username,   type: String
  field :full_name,  type: String
  field :location,   type: String
  field :homepage,   type: String
  field :admin,      type: Boolean, default: false
  field :rate_limit, type: Integer, default: 5000

  attr_protected :admin

  index({ email: 1 })
  index({ username: 1 })

  validates :username, uniqueness: true, allow_nil: true

  # Tell doorkeeper how to authenticate the resource owner with username/password
  def self.authenticate!(email, password)
    user = User.where(email: email).first
    return (user.valid_password?(password) ? user : nil) unless user.nil?
    nil
  end

  # Hack to let the model update also without pass
  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if params[:password].blank? || valid_password?(current_password)
      update_attributes(params, *options)
    else
      self.assign_attributes(params, *options)
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords
    result
  end
end
