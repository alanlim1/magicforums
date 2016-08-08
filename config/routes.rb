Rails.application.routes.draw do
  
  root to: 'landing#index'
  get :about, to: 'static_pages#about'
    resources :topics, except: [:show] do
    	resources :posts, except: [:show]
    end
    # /topics/:topic_id/posts/:id

    resources :posts, except: [:show] do
    	resources :comments
    end
    # /posts/:post_id/comments/:id
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end