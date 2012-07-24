FactoryGirl.define do
  factory :device, aliases: [:light] do
    name 'light'
    sequence(:resource_owner_id) { |n| n }
  end
end
