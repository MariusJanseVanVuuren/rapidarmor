class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
    render 'new'
  end

  def create
    users_email = params[:session][:email].strip.downcase
    @user = User.find_by(email: users_email)
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:success] = "Welcome back!"
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      if request.content_type == 'application/json'
        puts("Token : "+@user.remember_digest)

        render  json: {"token" => @user.remember_digest}
      else
        redirect_to @user
      end
    else
      if request.content_type == 'application/json'
        render status: 400, json: {
          message: "incorrect username or password",
        }.to_json
      else
        flash[:warning] = "You have entered incorrect email and/or password."
        render :new
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

end
