require 'resque/server'

Rails.application.routes.draw do

  https_constraint = (Rails.env.production? ? {protocol: 'https://'} : {})
  http_catchall    = (Rails.env.production? ? {protocol: 'http://'}  : -> (params, request) {false})

  namespace :admin, path: '/pastouch', constraints: https_constraint do
    get '/'        => 'monitoring#index', as: :root
    get '/metrics' => 'metrics#index'
  end

  get '/' => 'home#index'

  scope "(:locale)", locale: /en|fr/ do
    get 'comment-ca-marche' => 'home#faq', as: 'faq'

    scope 'early-adopter', constraints: https_constraint do
      get '/' => 'home#program', as: 'program'
      get 'reservez-votre-risebox' => 'program_leads#new', as: :new_program_lead
      resources :program_leads, only: :create
      get 'felicitations' => 'program_leads#congrats', as: :congratulations
    end
    match "early-adopter(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }

    resources :leads

    root 'home#index'
  end

  mount Resque::Server, at: '/jobs', as: 'jobs'

  # catch all /app and /pastouch without https and redirect to same url using https
  match "early-adopter(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }
  match "pastouch(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }
end
