Rails.application.routes.draw do
  resources :stations

  resources :tracks

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'stations#index'

  namespace :api, defaults: { format: :json } do
    scope module: :v1 do

     resources :stations

      resources :users, only: [] do
        resources :playlists do
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
    end
  end

end
