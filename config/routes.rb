Rails.application.routes.draw do
  root "readings#index"
  resources :readings, only: [:index, :new, :create, :destroy]
end
