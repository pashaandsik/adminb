# frozen_string_literal: true
module Admin
  module Forms
    class AdminLogin
      attr_reader :user, :controller
      delegate :params, :t, to: :controller

      def initialize(controller)
        @controller = controller
      end

      def errors
        @errors || {}
      end

      def login!
        email = params[:email].to_s.strip.downcase
        password = params[:password].to_s

        user = Admin::AdminUser.active.find_by(email: email)

        if user && user.check_password?(password)
          @user = user
          true
        else
          @errors = {
            email: [''],
            password: [t("errors.wrong_credentials")],
          }
          false
        end
      end
    end
  end
end
