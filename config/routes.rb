Bueller::Application.routes.draw do
  #get "welcome/index"

  # Homepage
  root "attendances#seating_chart"

  # Users
  resources :users, only: [:index, :show, :new, :create, :edit, :update]

  # Session resource should be limited to :new, :create and :destroy

  resource :sessions, only: [:new, :create, :destroy]

  # Attendance 
  resources :attendances, only: [:index, :show, :new, :create, :update]

  # Assignments
  resources :assignments do
    collection do
      get "import"
      post "import"
    end
  end


  # Account
  get "/signin" => "sessions#new"
  get "/signout" => "sessions#destroy"
  get "/signup" => "users#new"
  get '/sessions', to: redirect('/')

  # I'm here feature
  get "/iam-here" => "attendances#new"
  get "/attendances" => "attendances#index"
  get "/chart" => "attendances#seating_chart"



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
