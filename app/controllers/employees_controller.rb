class EmployeesController < ApplicationController
 def index
    @employees = Employee.all 
   
  end

  def new
    @employee= Employee.new
  end

  def create
    @employee = Employee.create(params[:employee])
    if @employee.save
      flash[:success] = "Added Employee"
      redirect_to employees_path
    else
      @title = "Add Employee"
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
