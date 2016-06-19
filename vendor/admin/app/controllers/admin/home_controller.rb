# frozen_string_literal: true
module Admin
  class HomeController < Admin::ApplicationController
    def index; end

    private

    def check_access
      true
    end
  end
end
