class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
  end
  def login
    user = User.authenticate(params[:username],params[:password])
    if user
      session[:user_id] = user.id
      flash[:success] = "Welcome  , you are now logged in!"

      redirect_to root_url

    else
      flash.now[:error] = "Invalid email or password"
      render "new"
    end
      
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end

end
