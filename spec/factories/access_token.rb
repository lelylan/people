FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    resource_owner_id Moped::BSON::ObjectId('000aa0a0a000a00000000000')
    application
    expires_in 2.hours
  end

  trait :with_device do
    after(:create) do |token|
      token.resources << FactoryGirl.build(:filtered_device)
      token.save
    end
  end

  trait :with_contained_devices do
    after(:create) do |token|
      token.resources << FactoryGirl.build(:filtered_contained_devices)
      token.save
    end
  end

  trait :with_location do
    after(:create) do |token|
      token.resources << FactoryGirl.build(:filtered_location)
      token.save
    end
  end
  
  trait :with_contained_locations do
    after(:create) do |token|
      token.resources << FactoryGirl.build(:filtered_contained_locations)
      token.save
    end
  end
end
