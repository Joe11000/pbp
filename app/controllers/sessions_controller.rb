class SessionsController < ApplicationController
	def create
		@user = User.find_or_build_from_omniauth(env['omniauth.auth'])
    if @user.valid?
      @user.special_save
  		session[:user_id] = @user.id
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

    if User.find_by_email(params["email"]).try(:authenticate, params["password"]).nil?
      redirect_to new_user_url
    else
      user = User.find_by_email(params[:email])
      session[:user_id] = user.id
      redirect_to root_url
    end
  end
end
