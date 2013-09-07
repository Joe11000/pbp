class UsersController < ApplicationController
  load_and_authorize_resource

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_url(@user)
    else
      flash[:notice] = "User Creation Failed"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id] )
    if @user.update_attributes(params[:user])
      redirect_to user_url(@user)
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
