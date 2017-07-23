Rails.application.routes.draw do
  resources :employees do
    post :reassign_project
  end
  resources :projects
end
