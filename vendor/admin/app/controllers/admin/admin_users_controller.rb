# frozen_string_literal: true
module Admin
  class AdminUsersController < Admin::ApplicationController
    before_action :init_form, only: %i[edit update]

    def index
      admins = Admin::AdminUser.order("created_at DESC")
      @admin_users = {
        active: admins.active,
        inactive: admins.inactive,
      }
    end

    def new
      @form = Admin::Forms::AdminUser.new
      render 'form'
    end

    def create
      @form = Admin::Forms::AdminUser.new(admin_user_params)
      if @form.create!
        redirect_to :admin_users, notice: "Admin user has been added."
      else
        render 'form'
      end
    end

    def edit
      @abilities = Admin::Ability.rights.fetch(@form.entity.role)
      render 'form'
    end

    def update
      if @form.update!(admin_user_params)
        redirect_to edit_admin_user_path(@form.id), notice: "Admin user has been saved."
      else
        render "form"
      end
    end

    def abilities
      @abilities = Admin::Ability.rights.fetch(params[:role])
      render "abilities", layout: false
    end

    private

    def init_form
      @form = Admin::Forms::AdminUser.find(params[:id])
    end

    def check_access
      authorize!(:manage, :admin_user)
    end

    def admin_user_params
      params.require(:admin_user).permit!
    end
  end
end
