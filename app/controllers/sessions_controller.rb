class SessionsController < ApplicationController
    def new
      # Show login form
    end
  
    def create
      user = User.find_by(email: params[:email])
      
      if user && user.authenticate(params[:password]) # Check password
        session[:user_id] = user.id  # Store user in session
        flash[:notice] = "Logged in successfully!"
        redirect_to root_path
      else
        flash.now[:alert] = "Invalid email or password"
        render :new
      end
    end
  
    def destroy
      session[:user_id] = nil # Logout user
      flash[:notice] = "Logged out successfully!"
      redirect_to login_path
    end
end
  