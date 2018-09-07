class CustomersController < ApplicationController
  def index
    @customers = Customer.all 
   
  end

  def new
    @customer= Customer.new
  end

  def create
    @customer = Customer.create(params[:customer])
    if @customer.save
      flash[:success] = "Application"
      redirect_to customers_path
    else
      @title = "Add Doctor"
      render 'new'
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
