Rails.application.routes.draw do

  resources :build_logs
  resources :annotations
  resources :submission_configs
  devise_for :users

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        passwords: 'api/v1/users/passwords',
        registrations: 'api/v1/users/registrations',
        confirmations: 'api/v1/users/confirmations',
      }
    end
    namespace :v1 do
      get 'me', controller: 'users/informations', action: :me, :defaults => { :format => :json }
      resources :users, controller: 'users/users', :defaults => { :format => :json } do
        get :places, controller: 'places', action: :user_places, :defaults => { :format => :json }
      end
      resources :places, controller: 'places', :defaults => { :format => :json } do
        resources :annotations, :defaults => { :format => :json }
        resources :images, :defaults => { :format => :json }
        resources :videos, :defaults => { :format => :json }
      end
      resources :annotations, controller: 'annotations', :defaults => { :format => :json }
      resources :maps, only: [:show, :index], :defaults => { :format => :json } do
        resources :layers, only: [:show], :defaults => { :format => :json } do
          resources :places do
            resources :images
            resources :annotations
            resources :videos
            member do
              delete :delete_image_attachment
              post :sort
              get :clone
              get :edit_clone
              patch :update_clone
            end
          end
        end

      end
      get 'regions', to: 'maps#index', as: :regions, :defaults => { :format => :json }
      get 'region/:id', to: 'maps#show_defaults', as: :region, :defaults => { :format => :json }
    end
  end

  root 'start#index'

  get 'info',      to: 'start#info'
  get 'notfound',  to: 'start#notfound'


  match 'preferences' => 'preferences#edit', :as => :preferences, via: [:get, :patch]

  get 'bomb',        to: 'application#bomb'
  post 'report_csp', to: 'application#report_csp'

  # settings
  get   'settings',  to: 'start#settings'

  # profile
  get   'edit_profile',    to: 'start#edit_profile'
  patch 'update_profile',  to: 'start#update_profile'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  resources :iconsets do
    resources :icons, only: [:edit, :destroy, :update]
  end
  resources :maps do
    resources :tags, only: [:index, :show]
    resources :relations
    resources :people
    resources :layers do
      collection do
        post :search
      end
      member do
        get :pack
        patch :build
        get :annotations
        get :relations
        get :images
      end
      resources :places do
        resources :images
        resources :videos
        member do
          delete :delete_image_attachment
          post :sort
          get :clone
          get :edit_clone
          patch :update_clone
        end
      end
    end
  end

  namespace :admin do
    resources :users
    # user search form
    post 'users_search', to: 'users#search'
    resources :groups
    resources :roles
  end

  scope "/:locale" do
    scope "/:layer_id" do
      resources :submissions, :controller => "public/submissions", only: [:new, :create, :edit, :update, :index] do
        get :new_place, :controller => "public/submissions", :action => 'new_place'
        post :create_place, :controller => "public/submissions", :action => 'create_place'
        scope "/:place_id" do
          get :edit_place, :controller => "public/submissions", :action => 'edit_place'
          patch :update_place, :controller => "public/submissions", :action => 'update_place'
          get :new_image, :controller => "public/submissions", :action => 'new_image'
          post :create_image, :controller => "public/submissions", :action => 'create_image'
          get :finished, :controller => "public/submissions", :action => 'finished'
        end
      end
    end
  end

  namespace :public do
    resources :maps, only: [:show, :index], :defaults => { :format => :json } do
      resources :layers, only: [:show], :defaults => { :format => :json }
    end
  end

end
