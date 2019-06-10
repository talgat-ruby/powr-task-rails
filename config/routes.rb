Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  get 'sessions/create'
  get 'sessions/destroy'
  root 'static_pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
