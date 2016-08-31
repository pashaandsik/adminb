# frozen_string_literal: true
module Admin
  class ApplicationController < ActionController::Base
    # before_action :check_ip
    before_action :require_user
    before_action :check_access
    before_action :set_locale

    delegate :current_user, :sign_in, :sign_out, :guest?, to: :user_session
    helper_method :current_user

    def user_session
      @user_session ||= Admin::UserSession.new(self)
    end

    private

    def page
      (params[:page] || 1).to_i
    end

    # def check_ip
    #   ips =  %w[127.0.0.1 192.168.1.111]
    #   raise "NotAllowed" unless ips.include?(request.remote_ip)
    # end

    def check_access
      return true unless current_user
      authorize!(:view, :basic_info)
    end

    def require_guest
      redirect_to :root and return if current_user
    end

    def require_user
      redirect_to :login and return unless current_user
    end

    def ability
      @ability ||= Admin::Ability.new(current_user)
    end

    delegate :can?, :cannot?, :authorize!, :editable_fields, to: :ability
    helper_method :can?, :cannot?

    def redirect_to_index(*args)
      redirect_to({ action: :index }, *args)
    end

    def set_locale
      I18n.locale = :en
    end
  end
end
