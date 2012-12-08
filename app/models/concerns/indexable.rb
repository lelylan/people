module Indexable
  extend ActiveSupport::Concern

  included do
    index({ resource_owner_id: 1, revoked_at: 1, scopes: 1, device_ids: 1 }, { background: true }) # Webhook service
    index({ resource_owner_id: 1 }, { background: true }) # Rate limit
  end
end
