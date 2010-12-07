class UsersController < ApplicationController
  filter_access_to :all

  def new
    @user = User.new
  end

  # GET /users
  # GET /users.xml
  def index
    @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 25, :page => params[:page])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "New user successfully created."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def profile
    @user = current_user
  end
  
  def update_profile
    @user = current_user
    params[:user][:role] = @user.role
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to root_url
    else
      render :action => 'profile'
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully saved user."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  private
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "email"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end
