class CustomersController < ApplicationController
  
  filter_access_to :all,  :except => [:show, :edit,:update,:beneficiaries,:create_beneficiary]
  filter_access_to [:show, :edit,:update,:beneficiaries,:create_beneficiary], :record_check => true, :load_method => lambda {Customer.find(params[:id])}
  def index
    @customers = Customer.all 
  end

  def new
    @customer= Customer.new()
    @nationalities = Nationality.all
  end

  def create
    @customer = Customer.create(params[:customer])
    @customer.application_number = rand(36**10).to_s(36)
    if @customer.save
      flash[:success] = "Application sent successfully" + "<br/> Application number  : #{@customer.application_number}. Please note it down to check the application status"
      redirect_to application_status_path
    else
      @title = "Add Doctor"
      render 'new'
    end
  end
  
  def check_application_status
  end
  def show_application_status
    @customers = Customer.search(params[:search])
  end
  def approve
    @customer = Customer.find(params[:id])
    @customer.application_status = "approved"
    @customer.save
    @customer_account = Customer.create_account(params[:id])
    flash[:success] = "Application approved."
    redirect_to customers_path
    
  end
  def reject
    @customer = Customer.find(params[:id])
    @customer.application_status = "rejected"
    @customer.save
    flash[:success] = "Application rejected."
    redirect_to customers_path
  end
  def revert
    @customer = Customer.find(params[:id])
    @customer_account=@customer.bank_account 
    if @customer.application_status == "approved"
      @customer_account.destroy
    end
              
    @customer.application_status = "pending"
    @customer.save
    flash[:success] = "Application pending."
    redirect_to customers_path
  end
        
  def edit
    @customer = Customer.find(params[:id]) 

  end

  def update
    @customer = Customer.find(params[:id])

    if @customer.update_attributes(params[:customer])
      flash[:success] = "Customer updated."
      redirect_to customer_path
    else
      @title = "Edit Profile"
      render 'edit'
    end
  end

  def show
    @customer = Customer.find(params[:id]) 
  end

  def destroy
    @customer = Customer.find(params[:id]) 
    @customer.destroy
    flash[:error] = "Customer Deleted."

    redirect_to customers_path

  end
  
  def beneficiaries
    
    @bank_account = current_user.record.bank_account
    @beneficiaries = @bank_account.beneficiaries         
    
  end
  
  def create_beneficiary
    @bank_account = current_user.record.bank_account
    @to_bank_account = BankAccount.search(params[:beneficiary][:to_bank_account])
    @account = @bank_account.beneficiary_accounts    
     
    if !@to_bank_account.nil? && !@account.find_by_account_number(params[:beneficiary][:to_bank_account]).present?  
      @beneficiary = @bank_account.beneficiaries.new(:beneficiary_name => params[:beneficiary][:beneficiary_name])
      @beneficiary.to_bank_account = @to_bank_account
      @beneficiary.save

      if @beneficiary.save
          
        flash[:success] = "Beneficiary addition request sent"
        redirect_to beneficiaries_customer_path
      else
      flash[:error] = "Beneficiary not saved "
        redirect_to :action => 'beneficiaries'
      end 
    else

      flash[:error] = "Invalid beneficiary account number or Beneficiary already added"
      redirect_to :back
    end    
        
            
  end
  
  def  approve_reject_beneficiaries
    
    @bank_account = BankAccount.find_by_id(params[:id])
    @beneficiary = @bank_account.beneficiaries.find(params[:approve_reject][:beneficary_account])
   
    if params[:approve_reject][:status] == "Approve"
      
      @beneficiary.status = "approved"
      
    else
      @beneficiary.status = "rejected"
    end
    @beneficiary.save

    redirect_to :controller => "bank_accounts" ,:action => 'beneficiaries_page'
  end
  
  

end
