require 'sidekiq/web'

Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  Spree::Core::Engine.routes.draw do
    namespace :admin do
      post 'products/import' => 'products#import'
    end

    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # just example, didn't add real ENV variables, can be implemented e.g. with gem 'dotenv-rails'
      username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
    end if Rails.env.production?
    mount Sidekiq::Web, at: "/sidekiq"
  end
end
