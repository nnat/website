require 'resque/server'

Rails.application.routes.draw do

  https_constraint = (Rails.env.production? ? {protocol: 'https://'} : {})
  http_catchall    = (Rails.env.production? ? {protocol: 'http://'}  : -> (params, request) {false})
  resque_app = Rack::Auth::Basic.new(Resque::Server) do |username, password|
    username == ENV['ADMIN_LOGIN'] && password == ENV['ADMIN_PWD']
  end

# mount protected_app in Rails

  # Concours 
  competition_url = "https://lafabrique-france.aviva.com/voting/projet/vue/851"
  constraints subdomain: "concours" do   
    get "/" => redirect { |params| competition_url }
  end
  get '/concours_lafabrique' => redirect(competition_url)

  #Sondage
  sondage_url = "https://risebox.typeform.com/to/w7wFmm"
  get '/sondage'             => redirect(sondage_url)

  namespace :admin, path: '/pastouch', constraints: https_constraint do
    get '/'        => 'monitoring#index', as: :root
    get '/metrics' => 'metrics#index'
    mount resque_app, at: '/jobs', as: 'jobs'
  end

  get '/' => 'home#index'

  scope "(:locale)", locale: /en|fr/ do
    get 'comment-ca-marche' => 'home#faq',     as: 'faq'
    get 'produit'           => 'home#specs',   as: 'specs'
    get 'notre-mission'     => 'home#mission', as: 'mission'
    get 'service'           => 'home#service', as: 'service'

    scope 'offre', constraints: https_constraint do
      get 'reservez-votre-risebox' => 'program_leads#new', as: :new_program_lead
      resources :program_leads, only: :create
      get 'felicitations' => 'program_leads#congrats', as: :congratulations
    end
    match "offre(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }

    resources :leads

    root 'home#index'
  end

  # catch all /app and /pastouch without https and redirect to same url using https
  match "offre(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }
  match "pastouch(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }
end
