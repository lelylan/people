FactoryGirl.define do
  factory :filtered_resource, aliases: %w(filtered_device) do
    resource_id   { FactoryGirl.create(:device).id }
    resource_type 'device'
    filtered_type 'device'

    factory :filtered_contained_devices do
      resource_id   { FactoryGirl.create(:location, :with_descendants).id }
      resource_type 'location'
      filtered_type 'device'
    end

    factory :filtered_location do
      resource_id   { FactoryGirl.create(:location).id }
      resource_type 'location'
      filtered_type 'location'
    end

    factory :filtered_contained_locations do
      resource_id   { FactoryGirl.create(:location, :with_descendants).id }
      resource_type 'location'
      filtered_type 'location'
    end
  end
end
