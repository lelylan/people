FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    resource_owner_id Moped::BSON::ObjectId('000aa0a0a000a00000000000')
    application
    expires_in 2.hours
  end

  trait :with_device do
    resources { [ FactoryGirl.build(:filtered_device) ] }
  end

  trait :with_contained_devices do
    resources { [ FactoryGirl.build(:filtered_contained_devices) ] }
  end

  trait :with_location do
    resources { [ FactoryGirl.build(:filtered_location) ] }
  end
  
  trait :with_contained_locations do
    resources { [ FactoryGirl.build(:filtered_contained_locations) ] }
  end
end
