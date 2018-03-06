class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
    render 'new'
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:success] = "Welcome back!"
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      if request.content_type == 'application/json'
        render  json: {"token" => @user.remember_digest}
      else
        redirect_to @user
      end
    else
      flash[:warning] = "You have entered incorrect email and/or password."
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

end
