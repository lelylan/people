FactoryGirl.define do
  factory :location, aliases: ['house'] do
    name 'House'
    sequence(:resource_owner_id) { |n| n }
    devices [BSON::ObjectId('500fb2d4d033a95185000001')]

    factory :floor do
      name 'Floor'
      devices [BSON::ObjectId('500fb2d4d033a95185000002')]
    end

    factory :room do
      name 'Room'
      devices [BSON::ObjectId('500fb2d4d033a95185000003')]
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
