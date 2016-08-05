require 'resque/server'

Rails.application.routes.draw do

  https_constraint = (Rails.env.production? ? {protocol: 'https://'} : {})
  http_catchall    = (Rails.env.production? ? {protocol: 'http://'}  : -> (params, request) {false})
  https_catchall    = (Rails.env.production? ? {protocol: 'https://'}  : -> (params, request) {false})
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

  # scope :constraints => { :protocol => "https" } do
  #   redirect { |params, request| "http://" + request.host_with_port + request.fullpath }
  # end
  get '/', constraints: https_catchall, to: redirect { |params, request| "http://" + request.host_with_port + request.fullpath }
  get '/' => 'home#index'

  match "*path", constraints: https_catchall, via: [:get], to: redirect { |params, request| "http://" + request.host_with_port + request.fullpath }

  scope "(:locale)", locale: /en|fr/ do
    get 'comment-ca-marche' => 'home#faq',     as: 'faq'
    get 'produit'         => 'product#show',   as: 'product'
    get 'services'           => 'home#services', as: 'services'
    get 'notre-mission'     => 'home#mission', as: 'mission'

class ConstraintsChain
  def initialize constraints_array
    @constraints_array = constraints_array
  end

  def matches? request
    matches = true
    @constraints_array.each do |c|
      matches = matches && c.matches?(request)
    end
    return matches
  end
end

class ValidVersion
  def matches? request
    request.params[:version].present? && ['ultime', 'minime'].include?(request.params[:version])
  end
end

class ValidOffer
  def matches? request
    request.params[:offer].present? && ['location', 'achat'].include?(request.params[:offer])
  end
end

    # scope 'reserver', constraints: https_constraint do
    scope 'reserver' do
      get '/' => 'versions#index', as: :versions
      get '/(:version)' => 'offers#index', as: :offers, constraints: ValidVersion.new
      get '/(:version)/(:offer)' => 'program_leads#new', as: :new_program_lead, constraints: ConstraintsChain.new([ValidVersion.new, ValidOffer.new])
      post '/(:version)/(:offer)' => 'program_leads#create', as: :create_program_lead, constraints: ConstraintsChain.new([ValidVersion.new, ValidOffer.new])
      get '/(:version)/(:offer)/felicitations' => 'program_leads#congrats', as: :congratulations, constraints: ConstraintsChain.new([ValidVersion.new, ValidOffer.new])
    end
    # match "reserver(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }

    resources :leads

    root 'home#index'
  end

  # catch all /app and /pastouch without https and redirect to same url using https
  # match "offre(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }
  match "pastouch(/*path)", constraints: http_catchall, via: [:get], to: redirect { |params, request| "https://" + request.host_with_port + request.fullpath }
end


