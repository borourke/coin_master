Rails.application.routes.draw do
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"

  root :to => "sessions#new"
  resources :users
  resources :sessions

  get '/', to: 'accounts#general_ledger'
  post '/', to: 'accounts#general_ledger'
  get '/general_ledger', to: 'accounts#general_ledger', as: 'general_ledger' 
  post '/general_ledger/create', to: 'accounts#save_transaction', as: 'general_ledgers'
end
