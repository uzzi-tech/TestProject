Rails.application.routes.draw do
  #devise_for :users
  root "sessions#new"  # Redirect to login page by default

  get "/signup", to: "registrations#new"   # Signup Page
  post "/signup", to: "registrations#create" # Handle Signup Submission
  
  get "/login", to: "sessions#new"    # Login Page
  post "/login", to: "sessions#create"  # Handle Login Submission
  delete "/logout", to: "sessions#destroy"  # Logout
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

 
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
