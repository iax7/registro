Rails.application.routes.draw do
  root 'welcome#index'

  get 'apiclient/ui'
  scope '/api' do
    scope '/v1' do
      get 'ping' => 'base_api#ping'
      get 'auth' => 'base_api#auth'
      put 'assist/:id' => 'base_api#assist', as: 'api_assist'
      put 'food/:day/:time/:id' => 'base_api#food'
      put 'food_correction/:day/:time/:id(/:commit)' => 'base_api#food_correction'
      get 'cancel/:hash' => 'base_api#cancel'
      get 'make_admin/:id(/:commit)' => 'base_api#make_admin', as: 'make_admin'
    end
  end

  resources :allocations
  resources :churches
  resources :configs
  resources :countries
  resources :posts
  resources :transports
  resources :foods do
    get 'totals', on: :collection
  end
  #resources :guests
  resources :hotels do
    get 'show_all', on: :collection
  end
  resources :states
  resources :people do
    get :autocomplete_country_name, on: :collection
    get :autocomplete_church_name, on: :collection
    get :autocomplete_state_name, on: :collection
    resources :guests
    get :payments, on: :collection
    get :totals, on: :collection
    get :comments, on: :collection
    get :graphs, on: :collection
  end

  get 'schedule' => 'welcome#schedule', as: 'schedule'

  get 'food_totals/:percent' => 'foods#totals', as: 'food_totals'

  get 'welcome/index'
  get 'mydata' => 'people#show', as: 'view_person'
  get 'editmydata' => 'people#edit', as: 'editmydata'

  # Reportes routes-----------------------------------------------------------------
  get 'registros' => 'reports#registros', as: 'registros'
  get 'gafete(/:id(/:inline))' => 'reports#gafete', as: 'gafete'
  get 'gafete_bulk' => 'reports#gafete_bulk', as: :gafete_bulk

  # Session Routes -----------------------------------------------------------------
  get 'login' => 'welcome#login', as: 'login'
  post 'login' => 'welcome#login'
  get 'logout' => 'welcome#logout', as: 'logout'
  get 'reset/:id/:verify' => 'welcome#reset', as: 'reset'
  post 'reset' => 'welcome#reset'
  get 'recover' => 'welcome#recover', as: 'recover'
  post 'recover' => 'welcome#recover'
  get 'helpadmin' => 'welcome#helpadmin', as: 'helpadmin'

  # Errors Routes ------------------------------------------------------------------
  get 'errors/file_not_found'
  get 'errors/unprocessable'
  get 'errors/internal_server_error'
  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # Let's Encrypt ------------------------------------------------------------------
  get '/.well-known/acme-challenge/:id' => 'welcome#letsencrypt'
end
