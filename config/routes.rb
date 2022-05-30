Rails.application.routes.draw do
  root 'user/home#index'

  get ':controller/:action'
  post ':controller/:action'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
