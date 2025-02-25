Rails.application.routes.draw do
  #devise_for :users
  root "sessions#new"  # Redirect to login page by default

  get "/signup", to: "registrations#new"   # Signup Page
  post "/signup", to: "registrations#create" # Handle Signup Submission
  
  #get "sessionshow", to: "sessions#show"  # Show current user information
  get "/login", to: "sessions#new"    # Login Page
  post "/login", to: "sessions#create"  # Handle Login Submission
  delete "/logout", to: "sessions#destroy"  # Logout
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  #---------------Projects Routes:
  get "/projects", to: "projects#index", as: "projects"
  get "/projects/new", to: "projects#new", as: "new_project"    
  post "/projects", to: "projects#create"  # Handle project creation
  get "/projects/:id", to: "projects#show", as: "project"
  get "/projects/:id/edit", to: "projects#edit", as: "edit_project" # Edit form
  patch "/projects/:id", to: "projects#update" # Update project
  delete "/projects/:id", to: "projects#destroy", as: "delete_project"# Delete project


  #----------Bugs Routes
  get "/projects/:project_id/bugs", to: "bugs#index", as: "project_bugs"
  get "/projects/:project_id/bugs/new", to: "bugs#new", as: "new_project_bug"
  post "/projects/:project_id/bugs", to: "bugs#create"
  get "/projects/:project_id/bugs/:id", to: "bugs#show", as: "project_bug"
  get "/projects/:project_id/bugs/:id/edit", to: "bugs#edit", as: "edit_project_bug"
  patch "/projects/:project_id/bugs/:id", to: "bugs#update"
  delete "/projects/:project_id/bugs/:id", to: "bugs#destroy", as: "delete_project_bug"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end