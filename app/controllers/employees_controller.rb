class EmployeesController < ApplicationController
  filter_access_to :all, :except => [:show,:edit]
  filter_access_to [:show,:edit],:attribute_check => true, :load_method => lambda {Employee.find(params[:id])}
  before_filter :find_employee, :only => [:edit,:show, :update, :destroy]
  def index
    @employees = Employee.all 
   
  end

  def new
    @employee= Employee.new
    @nationalities = Nationality.all
  end

  def create
    @employee = Employee.new(params[:employee])
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
    if @employee.update_attributes(params[:employee])
      flash[:success] = "Employee updated."
      redirect_to employee_path
    else
      @title = "Edit Employee"
      render 'edit'
    end
  end

  def show
    
  end

  def destroy
     if @employee.destroy
      flash[:success] = "Employee Deleted."
     else
      flash[:error] = "Could not be Deleted."
     end  
     redirect_to employees_path
  end
  
  private
  
  def find_employee
    @employee = Employee.find(params[:id])
  end
  
end
