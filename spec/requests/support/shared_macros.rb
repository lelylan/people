module SharedMacros
  # Database cleaner does not work with multiple databases
  def cleanup
    Doorkeeper::AccessToken.destroy_all
    Doorkeeper::AccessGrant.destroy_all
    Doorkeeper::Application.destroy_all
    User.destroy_all
    Device.destroy_all
    Location.destroy_all
  end
end

RSpec.configuration.include SharedMacros
