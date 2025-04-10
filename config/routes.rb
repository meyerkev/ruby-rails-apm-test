# config/routes.rb

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :payment_methods, only: [] do
        collection do
          post :tokenize
        end
      end
    end
  end
end