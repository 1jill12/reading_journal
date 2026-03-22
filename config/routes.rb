Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users
  root 'dashboard#index'
  patch '/theme', to: 'themes#update', as: :theme
  get   '/settings', to: 'settings#edit',   as: :settings
  patch '/settings', to: 'settings#update'
  resources :reading_goals, only: [:index, :create, :update, :destroy]
  get   '/stats', to: 'stats#index',   as: :stats
  get   '/feed',  to: 'feed#index',    as: :feed
  resources :users, only: [:index, :show]
  resources :follows, only: [:create]
  delete '/follows/:following_id', to: 'follows#destroy', as: :follow
  get    '/challenges',        to: 'challenges#index',    as: :challenges
  get    '/challenges/az',     to: 'az_challenges#index', as: :az_challenges
  delete '/challenges/az/:id', to: 'az_challenges#destroy', as: :az_challenge
  resources :bingo_cards, only: [:index, :show]
  resources :user_bingo_cards, only: [:create, :destroy]
  resources :books do
    collection { get :search }
    resources :reflections, only: [:create, :destroy]
    resource :review, only: [:edit, :create, :update, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
