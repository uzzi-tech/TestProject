class RegistrationsController < ApplicationController
    def new
      @user = User.new
    end
    
    def create
      @user = User.new(user_params)
  
      if @user.save
        session[:user_id] = @user.id  # Auto-login after signup
        flash[:notice] = "Account created successfully!"
        redirect_to root_path
      else
        Rails.logger.info "❌ SIGNUP FAILED: #{@user.errors.full_messages.join(", ")}"
        flash.now[:alert] = "Signup failed. Please check the errors below."
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_type)
    end
  end
  