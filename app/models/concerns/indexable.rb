# Add index to AccessToken for the webhook service

module Indexable
  extend ActiveSupport::Concern

  included do
    index({ resource_owner_id: 1, revoked_at: 1, scopes: 1, device_ids: 1 })
  end
end
