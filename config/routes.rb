Rails.application.routes.draw do
  
  root to: 'landing#index'
  get :about, to: 'static_pages#about'
  resources :users, only: [:new, :edit, :create, :update]
  resources :sessions, only: [:new, :create, :destroy]

    resources :topics, except: [:show] do
    	resources :posts, except: [:show]
    end
    # /topics/:topic_id/posts/:id

    resources :posts, except: [:show] do
    	resources :comments
    end
    # /posts/:post_id/comments/:id

    resources :password_resets
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end