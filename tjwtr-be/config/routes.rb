Rails.application.routes.draw do
  resources :posts
  post '/user/login' => 'user#login'
  post '/user/register' => 'user#register'
  patch '/user/update' => 'user#update'
end
