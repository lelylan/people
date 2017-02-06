FactoryGirl.define do
  factory :accessible_resource, aliases: %w(accessible_device) do
    resource_id   { FactoryGirl.create(:device).id }
    resource_type 'device'
    accessible_type 'device'

  end
end
