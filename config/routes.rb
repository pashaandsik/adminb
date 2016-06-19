# frozen_string_literal: true
Rails.application.routes.draw do
  constraints subdomain: "adm" do
    mount Admin::Engine, at: "/"
  end
end
