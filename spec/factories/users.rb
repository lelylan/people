FactoryGirl.define do
  factory :user do
    email    'alice@example.com'
    password 'password'
  end

  trait :with_all_attributes do
    after(:create) do |user|
      user.update_attributes(
        username:  'alice',
        full_name: 'Alice Bella',
        location:  'Fantasia',
        homepage:  'http://example.com')
    end
  end
end
