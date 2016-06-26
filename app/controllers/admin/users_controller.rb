class Admin::UsersController < ApplicationController

  before_action :set_user, :only => [:show, :update]

  def index
    @users = User.all
  end

  def show
  end

  def update
    @user.update(:role => params[:admin] )
    redirect_to admin_user_path(@user)
  end

  protected
  def set_user
    @user = User.find(params[:id])
  end
end
