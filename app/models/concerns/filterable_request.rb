# ResourceableRequest
#
# Add the resource list to the created access token.
# 
# The token is created from the data we jsut sent and from a base_toke. A base_token 
# change depending from the flow I'm using:
#
# - authorization code: base token is the previously created access grant token.
# - implicit grant:     base token is itself (better understand)
# - refresh token:      base token is the previous access token

module FilterableRequest
  extend ActiveSupport::Concern

  included do
    class_eval do
      private

      def create_access_token
        @access_token = Doorkeeper::AccessToken.create!({
          :application_id    => client.id,
          :resource_owner_id => base_token.resource_owner_id,
          :scopes            => base_token.scopes_string,
          :expires_in        => configuration.access_token_expires_in,
          :resources         => base_token.resources,
          :use_refresh_token => refresh_token_enabled?
        })
      end
    end
  end
end

