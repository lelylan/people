People::Application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { registrations: :registrations }
  devise_scope :user do
    get '/users/edit/password' => 'registrations#edit_password', as: 'edit_user_password'
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
end
