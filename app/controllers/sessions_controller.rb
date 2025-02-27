class SessionsController < ApplicationController
  def new
    # Show login form
  end

  # def show
  #   render json: session
  # end
  

  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password]) # Check password
      session[:user_id] = user.id  # Store user in session
      flash[:alert] = "Logged in successfully!"
      redirect_to projects_path
    else
      @user ||= User.new(email: params[:email])  # Preserve entered email in form
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil # Logout user
    flash[:alert] = "Logged out successfully!"
    redirect_to login_path
  end
end
