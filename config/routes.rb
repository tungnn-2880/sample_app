Rails.application.routes.draw do
  root "static_pages#home"
  get "/home", to: "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/register", to: "users#new"
  post "/register", to: "users#create"
  resources :users, only: %i(create new show)
end
