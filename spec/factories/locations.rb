FactoryGirl.define do
  factory :location, aliases: ['house'] do
    name 'House'
    sequence(:resource_owner_id) { |n| n }
    devices [1, 2]

    factory :floor do
      name 'Floor'
      devices [3, 4]
    end

    factory :room do
      name 'Room'
      devices [5, 6]
    end
  end

  trait :with_descendants do
    after(:create) do |house|
      floor = FactoryGirl.create :floor
      floor.move_to_child_of house
      room = FactoryGirl.create :room
      room.move_to_child_of floor
    end
  end
end
