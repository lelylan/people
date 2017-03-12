# Extension for fields saved from access token to refreshed access token.
# Used on refreshing token.

module ExtendableRefresh
  extend ActiveSupport::Concern

  included do
    class_eval do
      private

      def create_access_token
        @access_token = Doorkeeper::AccessToken.create!({
          :application_id    => refresh_token.application_id,
          :resource_owner_id => refresh_token.resource_owner_id,
          :scopes            => refresh_token.scopes_string,
          :device_ids        => refresh_token.device_ids,
          :resources         => refresh_token.resources,
          :expires_in        => server.access_token_expires_in,
          :use_refresh_token => server.refresh_token_enabled?
        })
      end
    end
  end
end
