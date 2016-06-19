# frozen_string_literal: true
module Admin
  class UserSession
    attr_reader :controller
    delegate :request, :params, :flash, :session, :logger, to: :controller

    # extend ActiveSupport::Memoizable

    def initialize(controller)
      @controller = controller
    end

    def current_user
      @current_user ||= find_current_user
    end

    # memoize :current_user


    def sign_in(user)
      cookies[:admin_user_id] = user.id
      true
    end

    def sign_out
      cookies[:admin_user_id] = nil
      @current_user = nil
      true
    end

    def guest?
      !current_user
    end

    private

    def cookies
      controller.send(:cookies).signed
    end

    def find_current_user
      user_id = cookies[:admin_user_id]
      Admin::AdminUser.active.find_by(id: user_id) if user_id
    end
  end
end
