MakerLabLMS::Application.routes.draw do


  resources :downloads


  resources :products


  resources :categories


  resources :guides do
    resources :articles
  end

  match '/' => 'guides#index', :constraints => { :subdomain => 'learn' }
  root :to => "home#index"

  authenticated :user do
    root :to => 'guides#index'
  end
  devise_for :users
  resources :users
end
