MakerLabLMS::Application.routes.draw do


  resources :categories


  resources :guides do
    resources :articles
  end


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end
