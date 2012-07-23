FactoryGirl.define do
  factory :user do
    email    'alice@example.com'
    password 'password'
    username 'alice'
  end

  trait :with_all_attributes do
    after(:create) do |user|
      user.update_attributes(
        full_name: 'Alice Bella',
        location:  'Fantasia',
        homepage:  'http://example.com')
    end
  end

  factory :bob, parent: 'user' do
    email    'bob@example.com'
    password 'password'
    username 'bob'
  end
end
