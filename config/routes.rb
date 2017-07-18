Rails.application.routes.draw do
  resources :projects
  resources :employees do
    post :reassign_project
  end
end
