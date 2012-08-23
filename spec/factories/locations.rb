FactoryGirl.define do
  factory :location, aliases: ['house'] do
    name 'House'
    resource_owner_id Settings.resource_id
    device_ids { [FactoryGirl.create(:device, name: 'House light', resource_owner_id: resource_owner_id).id ] }

    factory :floor do
      name 'Floor'
      device_ids { [FactoryGirl.create(:device, name: 'Floor light', resource_owner_id: resource_owner_id).id ] }
    end

    factory :room do
      name 'Room'
      device_ids { [FactoryGirl.create(:device, name: 'Room light', resource_owner_id: resource_owner_id).id ] }
    end
  end

  trait :with_descendants do
    after(:create) do |house|
      floor = FactoryGirl.create :floor, parent_id: house.id
      room  = FactoryGirl.create :room, parent_id: floor.id
    end
  end
end
