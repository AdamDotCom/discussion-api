Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, :defaults => { :format => 'json' } do
    resources :comments
  end

  resources :comments, :defaults => { :format => 'json' }

  resources :posts, :defaults => { :format => 'json' } do
    resources :comments
  end
end
