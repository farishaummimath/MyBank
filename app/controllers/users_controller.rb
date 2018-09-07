class UsersController < ApplicationController
  def index
    @users= User.all
  end

 

  def create
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
  
  def login
    
      
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
