MakerLabLMS::Application.routes.draw do


  resources :categories


  resources :guides do
    resources :articles
  end


  authenticated :user do
    root :to => 'guides#index'
  end
  root :to => "guides#index"
  devise_for :users
  resources :users
end
