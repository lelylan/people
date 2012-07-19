People::Application.routes.draw do
  devise_for :users

  use_doorkeeper
  root :to => 'home#index'
end
