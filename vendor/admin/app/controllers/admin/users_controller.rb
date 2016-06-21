# frozen_string_literal: true

module Admin
  class UsersController < Admin::ApplicationController
    before_action :init_form, only: %w[edit destroy update]

    def index
      @users = AdminDecorator.decorate_collection(::User.active.page(params[:page].to_i).per(10))
    end

    def new
      @form = Admin::Forms::User.new
      render "form"
    end

    def create
      @form = Admin::Forms::User.new(user_params)
      if @form.create!
        redirect_to :users, notice: "Пользователь добавлен."
      else
        render "form"
      end
    end

    def edit
      render "form"
    end

    def update
      if @form.update!(user_params)
        redirect_to :users, notice: "Пользователь обновлен."
      else
        render "form"
      end
    end

    def destroy
      @form.destroy!
      redirect_to :users, notice: "Пользователь удален."
    end

    private

    def check_access
      authorize!(:manage, :user)
    end

    def init_form
      @form = Admin::Forms::User.find(params[:id].to_i)
    end

    def user_params
      params.require(:user).permit(editable_fields(:user, current_user.role))
    end
  end
end
