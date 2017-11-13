Rails.application.routes.draw do
  resources :posts
  get '/login' => 'login#login'
  post '/register' => 'login#register'
  patch '/user' => 'login#update'
end
