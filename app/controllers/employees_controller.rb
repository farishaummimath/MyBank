class EmployeesController < ApplicationController
  filter_access_to :all, :except => [:show,:edit]
  filter_access_to [:show,:edit],:attribute_check => true, :load_method => lambda {Employee.find(params[:id])}
  def index
    @employees = Employee.all 
   
  end

  def new
    @employee= Employee.new
    @nationalities = Nationality.all
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
        @employee = Employee.find(params[:id])

  end

  def update
            @employee = Employee.find(params[:id])

    if @employee.update_attributes(params[:employee])
      flash[:success] = "Employee updated."
      redirect_to employee_path
    else
      @title = "Edit Doctor"
      render 'edit'
    end
  end

  def show
    @employee = Employee.find(params[:id])
    
  end

  def destroy
    @employee = Employee.find(params[:id])
     @employee.destroy
      flash[:success] = "Employee Deleted."
     redirect_to employees_path
  end
  
  def admin_dashboard
    
  end

end
