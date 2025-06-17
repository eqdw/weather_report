Rails.application.routes.draw do
  get 'forecasts',        to: 'forecasts#index'

  # Note: Strictly speaking, this should be a POST, because it is creating state on the back-end
  # However, the semantics of my app are such that the fact that this creates a record is irrelevant to
  # the client. From the client's perspective, for all they know, every possible weather forecast
  # already exists and they're just grabbing it. That, plus this way third party clients can
  # get the weather with just a url, without having to worry about submitting a form body.
  get 'forecasts/search', to: 'forecasts#search'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
