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
    root 'home#index'
    resources :leads
  end

  # catch all /app and /pastouch without https and redirect to same url using https
  match "pastouch(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }
end
