People::Application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { registrations: :registrations }
  devise_scope :user do
    get '/users/edit/password' => 'registrations#edit_password', as: 'edit_user_password'
  end

  use_doorkeeper do
    controllers applications: 'applications'
  end

  scope module: :api, defaults: {format: 'json'} do
    get :me, to: 'users#show'
  end
end
