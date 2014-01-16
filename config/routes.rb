MakerLabLMS::Application.routes.draw do


  resources :downloads


  resources :products


  resources :categories


  resources :guides do
    resources :articles
  end

  root :to => "home#index"
  match '/' => 'guides#index', :constraints => { :subdomain => 'learn' }

  authenticated :user do
    root :to => 'guides#index'
  end
  devise_for :users
  resources :users
end
