Rails.application.routes.draw do
  root :to => 'beautiful#dashboard'
  match ':model_sym/select_fields' => 'beautiful#select_fields', :via => [:get, :post]

  concern :bs_routes do
    collection do
      post :batch
      get  :treeview
      match :search_and_filter, :action => :index, :as => :search, :via => [:get, :post]
    end
    member do
      post :treeview_update
    end
  end

  # Add route with concerns: :bs_routes here # Do not remove
  resources :inspections, concerns: :bs_routes
  

  root to: 'inspections#index'
  devise_for :users
  resources :users
end
