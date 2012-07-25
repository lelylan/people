class Doorkeeper::OAuth::AccessTokenRequest
  private

  # Override the creation of the access token. 
  # The value of sase_token can be of two types:
  # - AccessGrant if we use the Authorization Code Flow
  # - AccessToken if we use the Implicit Authorization Flow
  def create_access_token
    @access_token = Doorkeeper::AccessToken.create!({
      :application_id    => client.id,
      :resource_owner_id => base_token.resource_owner_id,
      :scopes            => base_token.scopes_string,
      :expires_in        => configuration.access_token_expires_in,
      :devices           => base_token.devices,
      :use_refresh_token => refresh_token_enabled?
    })
  end
end

