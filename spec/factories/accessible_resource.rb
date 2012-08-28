FactoryGirl.define do
  factory :accessible_resource, aliases: %w(accessible_device) do
    resource_id   { FactoryGirl.create(:device).id }
    resource_type 'device'
    accessible_type 'device'

    factory :accessible_contained_devices do
      resource_id   { FactoryGirl.create(:location, :with_descendants).id }
      resource_type 'location'
      accessible_type 'device'
    end

    factory :accessible_location do
      resource_id   { FactoryGirl.create(:location).id }
      resource_type 'location'
      accessible_type 'location'
    end

    factory :accessible_contained_locations do
      resource_id   { FactoryGirl.create(:location, :with_descendants).id }
      resource_type 'location'
      accessible_type 'location'
    end
  end
end
