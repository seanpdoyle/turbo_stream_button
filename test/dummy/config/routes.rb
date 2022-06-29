Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :examples, only: [:create, :index]

  # Defines the root path route ("/")
  root to: redirect("/examples")
end
