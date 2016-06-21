module Admin
  class SessionsController < Admin::ApplicationController
    before_filter :require_guest, except: %w[destroy]
    before_filter :init_form,     only:   %w[new create]

    skip_before_filter :require_user,  only: %w[new create]

    def new
    end

    def create
      if @form.login!
        sign_in(@form.user)
        redirect_to :root
      else
       render :new
      end
    end

    def destroy
      sign_out
      redirect_to :root
    end

    private

    def init_form
      @form = Admin::Forms::AdminLogin.new(self)
    end
  end
end
