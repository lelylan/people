# Add the resource list to the created access token.
#
# The token is created from the data we jsut sent and from a base_toke. A base_token
# change depending from the flow I'm using:
#
# - authorization code: base token is the previously created access grant token.
# - implicit grant:     base token is itself (better understand)
# - refresh token:      base token is the previous access token

module AccessibleRequest
  extend ActiveSupport::Concern

  included do
    class_eval do
      private

      def create_access_token
        #expires_in = grant.expirable ? configuration.access_token_expires_in : nil
        @access_token = Doorkeeper::AccessToken.create!({
          :application_id    => grant.application_id,
          :resource_owner_id => grant.resource_owner_id,
          :scopes            => grant.scopes_string,
          :device_ids        => grant.device_ids,
          :location_ids      => grant.location_ids,
          :resources         => grant.resources,
          :expires_in        => server.access_token_expires_in,
          :use_refresh_token => server.refresh_token_enabled?
        })
      end
    end
  end
end

