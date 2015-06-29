class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:session][:name], params[:session][:password])
    if user
      session[:user_id] = user.id
      redirect_to general_ledger_path, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end