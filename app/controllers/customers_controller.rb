class CustomersController < ApplicationController
  
  filter_access_to :all,  :except => [:show, :edit,:update,:beneficiaries,:create_beneficiary]
  filter_access_to [:show, :edit,:update,:beneficiaries,:create_beneficiary], :attribute_check => true, :load_method => lambda {Customer.find(params[:id])}
  before_filter :find_customer, :only => [:approve,:reject, :revert,:edit,:show, :update, :destroy]
  def index
    @customers = Customer.paginate :page => params[:page], :order => 'updated_at DESC'

  end

  def new
    @customer= Customer.new()
    @nationalities = Nationality.all
  end

  def create
    @customer = Customer.new(params[:customer])
    @customer.application_number = rand(36**10).to_s(36)
    if @customer.save
      flash[:success] = "Application sent successfully" + "<br/> Application number  : #{@customer.application_number}. Please note it down to check the application status"
      redirect_to application_status_path
    else
      render 'new'
    end
  end
  
  def check_application_status
  end
  def show_application_status
    @customers = Customer.search(params[:search])
  end
  def approve
    if @customer.update_attributes(:application_status => "approved")
       @user = @customer.user
       if Customer.create_account(params[:id],@user)
         flash[:success] = "Application approved and bank Account created"
       end
    else
      flash[:error] = "Something went wrong"
    end  
    redirect_to customers_path
    
  end
  def reject
    if @customer.update_attributes(:application_status => "rejected")
      flash[:success] = "Application rejected."
    else
      flash[:success] = "Application cannot be rejected."
    end 
    redirect_to customers_path
  end
  def revert
    @customer_account=@customer.bank_account 
    if @customer.application_status == "approved"
      if @customer_account.destroy
        flash[:success] = "Application reverted to pending and deleted bank account."
      end
    end
              
    if @customer.update_attributes(:application_status => "pending")
      flash[:success] = "Application reverted to pending."
    end
    redirect_to customers_path
  end
        
  def edit

    
  end

  def update

    if @customer.update_attributes(params[:customer])
      flash[:success] = "Customer updated."
      redirect_to customer_path
    else
      render 'edit'
    end
  end

  def show
  end

  def destroy
    if @customer.destroy
      flash[:error] = "Customer Deleted."
    else
      flash[:error] = "Something went wrong."
    end
    redirect_to customers_path

  end
  
  def beneficiaries
    
    @bank_account = current_user.record.bank_account
    @beneficiaries = @bank_account.beneficiaries         
    
  end
  
  def create_beneficiary
    @bank_account = current_user.record.bank_account
    @to_bank_account = BankAccount.find_by_account_number(params[:beneficiary][:to_bank_account].to_i)
    @account = @bank_account.beneficiary_accounts    
    if params[:beneficiary][:to_bank_account].present? 
      if !@to_bank_account.nil? && 
        !@account.find_by_account_number(params[:beneficiary][:to_bank_account]).present?  
        @beneficiary = @bank_account.beneficiaries.new(:beneficiary_name => params[:beneficiary][:beneficiary_name],:to_bank_account =>@to_bank_account )
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
    else
      flash[:error] = "Invalid input"
      redirect_to :back
        
    end        
  end
  
  def  approve_reject_beneficiaries    
    @bank_account = BankAccount.find(params[:id])
    @beneficiary = @bank_account.beneficiaries.find(params[:approve_reject][:beneficary_account])
    if params[:approve_reject][:status] && @beneficiary.status == "pending"
      if params[:approve_reject][:status] == "Approve"
        if @beneficiary.update_attributes(:status => "approved")
          flash[:success]  = "Approved beneficiary"
        end      
      elsif params[:approve_reject][:status] == "Reject"
        if @beneficiary.update_attributes(:status => "rejected")
            flash[:success]  = "Rejected beneficiary"
        end 
      else
        flash[:error] = "Can't select option"
      end  
    else
      flash[:error] = "please select option"
    end
    
    redirect_to :back
  end
end

private
def find_customer
    @customer = Customer.find(params[:id])
end
