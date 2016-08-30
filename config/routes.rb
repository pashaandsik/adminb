# frozen_string_literal: true
require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  constraints subdomain: "adm" do
    mount Admin::Engine, at: "/"

    Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
      [user, password] == [ENV["SIDEKIQ_USER"], ENV["SIDEKIQ_PASSWORD"]]
    end

    mount Sidekiq::Web => '/sidekiq'
  end
end
