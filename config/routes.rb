MakerLabLMS::Application.routes.draw do


  resources :downloads


  resources :products


  resources :categories


  resources :guides do
    resources :articles
  end

  match '/' => 'guides#index', :constraints => { :subdomain => 'learn' }

  authenticated :user do
    root :to => 'guides#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end
