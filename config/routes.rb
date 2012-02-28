Specifications::Application.routes.draw do



  resources :userstories do
    resources :comments, :only => [:create, :destroy]
  end

  delete "/userstories/:id" => "userstories#destroy", :as => :destroy_userstory
  put "/userstories/:id" => "userstories#update", :as => :update_userstory

  post "projects/:project_id/userstories/sort" => "userstories#sort", :as => :sort_userstories
  
  post "projects/:project_id/feature/sort" => "features#sort", :as => :sort_features
  
  post "versions/:id/revert" => "versions#revert", :as => :revert_version

  get "projects/:id/activity" => "projects#activity", :as => :project_activity

  resources :projects do
    resources :features do
      resources :userstories, :only => [:create] 
    end
    resources :stakeholders, :only => [:index, :create, :destroy]
  end

  get "projects/:project_id/userstories/:id" => "userstories#show", :as => :project_userstory
 
  resources :invitations
  resources :users, :only => [:show, :create, :index, :destroy]
  resources :sessions, :only => [:new, :create, :destroy]
  match '/invitation',    :to => 'invitations#new'
  match '/signup/:invitation_token',  :to => 'users#new', :as => 'signup'
  match '/login',  :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy'
  root :to => 'pages#home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
