# Override Doorkeeper::OAuth::AccessTokenRequest
#
# Create the access token. The token is created from the data we jsut sent and from 
# a base_toke. A base_token change depending from the flow I'm using
# - Authorization code: base token is the previously created access grant token.
# - Implicit grant:     base token is itself (better understand)
# - Refresh token:      base token is the previous access token
#
# What we do is simply adding the device list.

class Doorkeeper::OAuth::AccessTokenRequest
  private

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

