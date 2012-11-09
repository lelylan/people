# Extension for fields saved from grant token to access token.
# Used on authorization code flow (not implicit grant, as it directly create the access token).

module ExtendableAuthorization
  extend ActiveSupport::Concern

  included do
    class_eval do
      private

      def create_access_token
        @access_token = Doorkeeper::AccessToken.create!({
          :application_id    => grant.application_id,
          :resource_owner_id => grant.resource_owner_id,
          :scopes            => grant.scopes_string,
          :device_ids        => grant.device_ids,
          :location_ids      => grant.location_ids,
          :resources         => grant.resources,
          :expires_in        => grant.expires_in,
          :use_refresh_token => server.refresh_token_enabled?
        })
      end
    end
  end
end

