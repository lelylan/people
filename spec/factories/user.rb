FactoryGirl.define do
  factory :user do
    email    'alice@example.com'
    password 'password'
    username 'alice'
  end

  factory :bob, parent: 'user' do
    email    'bob@example.com'
    password 'password'
    username 'bob'
  end

  factory :admin, parent: 'user' do
    email    'admin@example.com'
    password 'password'
    username 'admin'
    admin    true
  end

  trait :with_all_attributes do
    after(:create) do |user|
      user.update_attributes(
        full_name: 'Alice Bella',
        location:  'Fantasia',
        homepage:  'http://example.com')
    end
  end

  trait :as_admin do
    after(:create) do |user|
      user.admin = true
      user.save
    end
  end
end
