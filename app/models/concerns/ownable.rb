# Ownable
# 
# Add the field resource_owner_id to show only the owned resources.

module Ownable
  extend ActiveSupport::Concern

  included do
    field          :resource_owner_id, type: Integer
    attr_protected :resource_owner_id
    validates      :resource_owner_id, presence: true
  end
end
