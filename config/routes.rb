Rails.application.routes.draw do
  # get 'health_check/index'

  resources :health_check, :only => [:index] do
  end
  

  resources :trails do 
    get :search, on: :collection
  end
  
  jsonapi_resources :trails


end
