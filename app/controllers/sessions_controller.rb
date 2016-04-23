class SessionsController < ApplicationController

  def new
  end

  def create
    @volunteer = Volunteer.find_by(username: params[:session][:username])
    #if vurrent_volunterr == admin go to admin/dashboard
    if @volunteer && @volunteer.authenticate(params[:session][:password])
      session[:volunteer_id] = @volunteer.id
      flash[:notice] = "Logged in as #{@volunteer.username}"
      if @volunteer.admin?
        flash[:notice] = "You have been logged in as an admin"
        redirect_to admin_dashboard_path
      elsif session[:cart].nil?
        redirect_to dashboard_path
      else
        redirect_to cart_path
      end

    else
      flash.now[:error] = "Invalid. Please try again."
      render :new
    end
  end

  def destroy
    session.clear
    flash[:warning] = "Logged out!"
    redirect_to root_path
  end

end