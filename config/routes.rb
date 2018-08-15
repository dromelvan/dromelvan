Rails.application.routes.draw do

  root to: 'home#index'

  get '/rules' => 'home#rules'
  get '/about' => 'home#about'
  
  get '/search' => 'search#search'
  get '/live_search' => 'search#live_search'

  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#rejected_change", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  devise_for :users, skip: :registrations, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  devise_scope :user do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'devise/registrations',
      as: :user_registration do
        get :cancel
      end  
  end
  
  concern :select do
    collection do
      post :select
    end
  end

  concern :select_season do
    member do
      post :select_season
      get '/:season_id', action: :show, as: 'show_season'
    end    
  end

  concern :table do
    collection do
      post :select_table
    end
    member do
      get :show_table, path: 'table'
    end
  end

  concern :d11_teams do
    collection do
      post :select_d11_teams, path: 'd11-teams'
    end
    member do
      get :show_d11_teams, path: 'd11-teams'
    end
  end
  
  concern :stats do
    collection do
      post :select_stats
    end
    member do
      get :show_stats, path: 'stats'
    end
  end

  concern :fixtures do
    collection do
      post :select_fixtures
    end
    member do
      get '/:season_id/fixtures', action: :show_fixtures, as: 'show_fixtures'
    end
  end
  
  concern :transfer_bids do
    collection do
      post :select_transfer_bids
    end
    member do
      get :show_transfer_bids, path: 'transfer-bids'
    end
  end

  concern :transfer_listings do
    collection do
      post :select_transfer_listings
    end
    member do
      get :show_transfer_listings, path: 'transfer-listings'
    end
  end

  concern :status_enum do
    member do
      get :pend
      get :activate
      get :finish
    end    
  end
  
  resources :seasons, only: [:index, :show], concerns: [:select]
  resources :teams, only: [:show], concerns: [:select_season, :select, :fixtures]
  resources :players, only: [:show, :new, :create], concerns: [:select_season] do
    member do
      post 'update_whoscored_id/:whoscored_id', action: :update_whoscored_id, as: "update_whoscored_id"
    end
  end
  resources :player_season_infos, only: [:edit, :update] do
    member do
      post 'create_current'
    end
  end
  resources :premier_leagues, only: [:show], concerns: [:select, :table, :stats], path: 'premier-leagues' do
    member do
      get 'printable_player_list', path: 'printable-player-list'
    end
  end
  resources :match_days, only: [:show, :update], concerns: [:select, :status_enum], path: 'match-days' do
    member do
      get 'update_stats'
    end        
  end
  resources :matches, only: [:show, :update], concerns: [:select, :status_enum] do
    member do
      get 'edit_match_stats'
    end
    member do
      post 'update_match_stats'
    end
    member do
      get 'postpone'
    end
  end
  resources :d11_leagues, only: [:show], concerns: [:select, :table, :d11_teams], path: 'd11-leagues'
  resources :d11_match_days, only: [:show, :update], concerns: [:select], path: 'd11-match-days'
  resources :d11_matches, only: [:show], concerns: [:select], path: 'd11-matches'
  resources :d11_teams, only: [:show], concerns: [:select_season, :select, :fixtures], path: 'd11-teams'
  resources :transfer_windows, only: [:show, :new, :create], concerns: [:select], path: 'transfer-windows'
  resources :transfer_days, only: [:show], concerns: [:select, :transfer_bids, :transfer_listings, :status_enum], path: 'transfer-days'
  resources :transfer_listings, only: [:index, :create, :destroy]
  resources :transfer_bids, only: [:new, :create, :edit, :update, :destroy]
  resources :transfers, only: [:new, :create ]
  resources :team_table_stats, only: [:index]
  resources :player_season_stats, only: [:index]
  resources :d11_team_table_stats, only: [:index]
  resources :posts, except: [:destroy]
    
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :api do
    namespace :v1 do
      resources :seasons, only: [:index, :show] do
        collection do
          get 'current'
        end
      end
      resources :matches, only: [:show, :update] do
        member do
          put 'update_match_stats'
        end        
        collection do
          get 'by_date/:date', action: :by_date, as: 'by_date'
        end
      end
      resources :users, only: [] do
        collection do
          get 'request_authentication_token'
        end                
      end
      resources :teams, only: [] do
        collection do
          get 'named/:name', action: :named, as: 'named'
          get ':id/squad', action: :squad, as: 'squad'
        end
      end
      resources :players, only: [:show] do
        collection do
          get 'named/:name', action: :named, as: 'named'
        end
      end            
      resources :match_days, only: [:show] do
        collection do
          get 'current'
          get 'upcoming'
          get 'by_season/:season_id', action: :by_season, as: 'by_season'
        end
      end
    end
  end
  
end
