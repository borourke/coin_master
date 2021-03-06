Rails.application.routes.draw do
  get "log_out", to: "sessions#destroy", :as => "log_out"
  get "log_in", to: "sessions#new", :as => "log_in"

  root :to => "sessions#new"
  resources :users
  resources :sessions

  get '/', to: 'accounts#general_ledger'
  post '/', to: 'accounts#general_ledger'
  delete '/general_ledger/:id', to: 'accounts#delete_transaction', as: 'delete_transaction'
  get '/general_ledger', to: 'accounts#general_ledger', as: 'general_ledger' 
  post '/general_ledger/create', to: 'accounts#save_transaction', as: 'general_ledgers'
  get '/summary', to: 'accounts#summary', as: 'summary'
  post '/summary', to: 'accounts#summary', as: 'custom_forecast_date' 
end
