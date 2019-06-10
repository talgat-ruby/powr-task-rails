Rails.application.routes.draw do
  get 'sessions/error'
  get 'login', to: redirect('https://github.com/login/oauth/authorize?' + { client_id: ENV['CLIENT_ID'] }.to_query)
  get 'sessions/new'
  get 'sessions/create'
  root 'static_pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
