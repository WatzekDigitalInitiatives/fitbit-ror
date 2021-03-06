Rails.application.routes.draw do
    resources :teams
    devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:registrations]
    resources :events
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    root 'pages#home'

    get '/home' => 'pages#home', :as => :home
    get '/dashboard' => 'pages#dashboard', :as => :dashboard

    get '/joinevent' => 'user_events#new', :as => :join_event
    post '/user_events/create' => 'user_events#create'
    delete '/user/:user_id/event/:event_id(.:format)' => 'user_events#destroy', :as => :user_events_destroy

    get '/jointeamevent/:id' => 'team_events#new', :as => :join_team_event
    post '/team_events/create' => 'team_events#create'

    get '/jointeam' => 'user_teams#new', :as => :join_team
    post '/user_teams/create' => 'user_teams#create'
    delete '/team/:team_id(.:format)' => 'user_teams#destroy', :as => :leave_team

    get '/myevents' => 'events#myevents', :as => :my_events
    get '/myteams' => 'teams#myteams', :as => :my_teams
    get '/about' => 'pages#about', :as => :about

    match '/push' => 'activities#verifysub', via: :get
    match '/push' => 'activities#pushnotification', via: :post
    # post '/push' => 'activities#push'

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
