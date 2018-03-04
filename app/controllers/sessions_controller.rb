class SessionsController < ApplicationController
  def new
    render 'new'
  end

  def create
    @user = User.find_by(email: params["session"][:email])
    if @user && @user.authenticate(params["session"][:password])
      session[:user_id] = @user.id
      flash[:success] = "Welcome back!"
      log_in @user
      redirect_to @user
    else
      flash[:warning] = "You have entered incorrect email and/or password."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path
  end

end
