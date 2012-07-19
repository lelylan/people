People::Application.routes.draw do

  root to: 'home#index'

  devise_for :users
  devise_scope :user do
    get "/users/edit/password" => "registrations#change", as: 'change_password'
  end

  use_doorkeeper

end
