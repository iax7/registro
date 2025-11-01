Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :payments
  root "main#index"

  resources :registries do
    get "totals(/:name)", to: "registries#totals", on: :collection, as: :totals # Creates: totals_registries_path
    get "totals_food(/:name)", to: "registries#totals_food", on: :collection, as: :totals_food
    get :list_lodging, on: :collection
    get :list_transport, on: :collection
    get :edit_payment
    resources :guests # , shallow: true # only: [:index, :new, :create]
  end
  resources :users do
    get :payments, on: :collection
    get :revoke_admins, on: :collection
  end

  get "autocomplete/countries/:string" => "autocomplete#countries", as: :autocomplete_countries
  get "autocomplete/states/:string" => "autocomplete#states", as: :autocomplete_states
  get "autocomplete/cities/:string" => "autocomplete#cities", as: :autocomplete_cities

  # Session Routes -------------------------------------------------------------
  get "login" => "access#login", as: "login"
  get "logout" => "access#logout", as: "logout"
  post "access/attempt_login"
  match "access/reset_request" => "access#reset_request", as: :reset_request, via: [:get, :post]
  match "access/reset(/:token)" => "access#reset", as: :access_reset, via: [:get, :post]

  # API Routes -----------------------------------------------------------------
  get "apiui/index"
  scope "/api" do
    scope "/v1" do
      get "ping" => "api#ping"
      get "change_pwd/:user_id/:password" => "api#change_pwd"
      get "admin/:id(/:commit)" => "api#admin"
      get "cancel/:hash" => "api#cancel"
      put "assist/:id" => "api#assist"
      put "food/:day/:time/:id" => "api#food"
      put "food_correction/:day/:time/:id(/:commit)" => "api#food_correction"
    end
  end

  # Admin --------------------------------------------------------------------------
  resources :events do
    get :calculate_statistics
  end

  # Reports ------------------------------------------------------------------------
  get "badge(/:id(/:inline))" => "reports#badge", as: "badge"
  get "badge_bulk" => "reports#badge_bulk", as: "badge_bulk"

  # Let's Encrypt ------------------------------------------------------------------
  # get '/.well-known/acme-challenge/:id' => 'main#letsencrypt'

  # Errors Routes ------------------------------------------------------------------
  # if Rails.env.production?
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unprocessable"
  get "/500", to: "errors#internal_server_error"
end
