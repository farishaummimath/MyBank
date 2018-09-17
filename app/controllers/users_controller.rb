class UsersController < ApplicationController
  def index
    @users= User.all
  end
  
  def login_page
    @title = "Login"
    
  end
 

  def login
    user = User.authenticate(params[:user])
    if user 
      if user.is_active == true
       session[:user_id] = user.id
       flash.now[:success] = "Welcome  , you are now logged in!"
       #redirect_to current_user.record
       redirect_to root_path
      else
       flash.now[:error] = "Login inactive"
       render "login_page"
      end      
    else
      flash.now[:error] = "Invalid email or password"
      render "login_page"
    end      
    
  end
  
  def show

    @user= User.find(params[:id])
    
    
  end
  
  def logout
    
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
  

  def destroy
    @user= User.find(params[:id])
    @user.destroy
    redirect_to users_path

    
  end

end
