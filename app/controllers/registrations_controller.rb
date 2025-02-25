class RegistrationsController < ApplicationController
    def new
      @user = User.new
    end
    
    def create
      @user = User.new(user_params)
  
      if @user.save
        flash[:notice] = "Account created successfully!"  #flash is used to store temporary messages that persist across redirects.
        redirect_to root_path
      else
        Rails.logger.info "❌ SIGNUP FAILED: #{@user.errors.full_messages.join(", ")}"
        flash.now[:alert] = "Signup failed. Please check the errors below."
        render :new, status: :unprocessable_entity  #he request was understood, but data validation failed.
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_type)
    end
  end
  