Rails.application.routes.draw do

  resources :users, only: [:new, :create, :index, :show]

end
