People::Application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { registrations: :registrations }
  devise_scope :user do
    get '/users/password/change' => 'registrations#edit_password'
  end

  scope 'oauth/authorize' do
    resources :devices, only: %w(index create destroy)
  end

  use_doorkeeper do
    controllers applications: 'applications', authorizations: 'authorizations'
  end

  scope module: :api, defaults: {format: 'json'} do
    get :me, to: 'users#show'
  end

  # OPEN_SIGNUP: remove the subscription routes, controller and model
  resources :subscriptions do
    match :invite,     via: :get, on: :collection
    match :later,      via: :put, on: :collection
    match :prioritize, via: :put, on: :collection
    match :see_later,  via: :get, on: :collection
  end
end
