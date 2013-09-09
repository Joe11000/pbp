class SessionsController < ApplicationController
	def create
		@user = User.find_or_build_from_omniauth(env['omniauth.auth'])
		session[:user_id] = @user.id
    if @user.valid?
      @user.save
		  redirect_to root_url
    else
      flash[:notice] = "Add first name, last name and email to finish user creation."
      render template: 'users/new'
    end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_url
	end

  def sign_in
    @user = User.find(params[:id])
    if @user.authenticate(params[user])
      session[:user_id]
      redirect_to root_url
    else
      render template: 'user/new'
    end
  end
end
