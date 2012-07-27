FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    resource_owner_id Moped::BSON::ObjectId('000aa0a0a000a00000000000')
    sequence(:name){ |n| "Application #{n}" }
    redirect_uri 'http://app.dev/callback'
  end
end
