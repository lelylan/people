FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    sequence(:resource_owner_id) { |n| n }
    sequence(:name){ |n| "Application #{n}" }
    redirect_uri 'http://app.dev/callback'
  end
end
