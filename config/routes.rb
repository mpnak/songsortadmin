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

     resources :stations

      resources :users, only: [] do
        resources :playlists, only: [:index, :new, :create] do
          resources :tracks, only: [] do
            member do
              post "play"
              post "skipped"
              post "favorited"
              post "banned"
            end
          end
        end
      end

      resources :playlists, only: [:show, :edit, :update, :destroy]
    end
  end

end
