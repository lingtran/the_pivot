class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def admin_index
    @company_name = Company.find(params[:company_id]).name
    @users = User.company_users(params[:company_id])
  end

  def new
    if current_user.nil?
      @user = User.new
      @title = "Create Account"
    else
      @company_id = params[:company_id] if current_user.platform_admin?
      @company_id = current_user.company_id if current_user.store_admin?
      flash[:error] = "Admin is missing a company id" if @company_id.nil?
      @user = User.new
      @title = "Create Administrator"
    end
  end

  def create
    if !current_user.nil?
      @user = User.create(admin_params)
      @user.add_store_admin_role
      role_redirect
    else
      @user = User.new(user_params)
      if @user.save
        @user.add_registered_user_role
        session[:user_id] = @user.id
        flash[:notice] = "Account Created! Logged in as #{@user.first_name}"
        if !session[:favorites].nil?
          UsersJob.favorite_jobs_from_session(session[:favorites], current_user)
          session[:favorites] = {}
        end
        role_redirect
      else
        flash.now[:error] = "Invalid. Please try again."
        render :new
      end
    end
  end

  def show
    @user = current_user
    render file: '/public/404' if current_user.nil?
    render 'users/platform_admin' if current_user.platform_admin?
    render 'users/store_admin' if current_user.store_admin?
    # will default to show.html.erb (if guest)
  end

  def edit
    render file: '/public/404'
  end

  private

  def role_redirect
    if @user.platform_admin?
      flash[:notice] = "Welcome Super Admin, #{@user.first_name}"
      redirect_to platform_admin_dashboard_path
    elsif @user.store_admin?
      flash[:notice] = "Welcome #{@user.first_name}"
      redirect_to store_admin_dashboard_path
    else
      flash[:notice] = "Account Created! Logged in as #{@user.first_name}"
      redirect_to dashboard_path
    end
  end

  def user_params
    params.require(:user).permit(
    :first_name,
    :last_name,
    :email,
    :password,
    :password_confirmation)
  end

  def admin_params
    params.require(:user).permit(
    :first_name,
    :last_name,
    :email,
    :password,
    :password_confirmation,
    :company_id)
  end
end
