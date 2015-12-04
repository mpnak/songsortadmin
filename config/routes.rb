Rails.application.routes.draw do
  resources :stations

  resources :tracks

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'stations#index'

  namespace :api, defaults: { format: :json } do
    scope module: :v1 do

      namespace :spotify do
        post "swap"
        post "refresh"
      end

      resources :stations do
        member do
          post "tracks" => "stations#generate_tracks"
        end
      end

      resources :users, only: [] do
        resources :saved_stations, only: [:index, :new, :create]
      end

      resources :saved_stations, only: [:show, :edit, :update, :destroy] do
        member do
          post "tracks" => "tracks#generate_tracks"
          get "tracks"
        end
      end

      resources :tracks, only: [] do
        member do
          post "play"
          post "skipped"
          post "favorited"
          post "unfavorited"
          post "banned"
        end
      end

    end
  end

end
