Rails.application.routes.draw do
  get '/general_ledger', to: 'accounts#general_ledger', as: 'general_ledger' 
  get '/general_ledger/new', to: 'accounts#new_transaction', as: 'new_transaction'
  post '/general_ledger/create', to: 'accounts#save_transaction', as: 'general_ledgers'
end
