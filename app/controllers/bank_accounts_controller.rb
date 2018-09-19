class BankAccountsController < ApplicationController
  filter_access_to :all,  :except => [:show,:customer_transactions_statement,:transactions_page,:bank_transactions_statement,:account_closure,:transfer,:my_transactions_statements,:export_statement_csv]
  filter_access_to [:show,:transactions_page,:customer_transactions_statement,:bank_transactions_statement,:account_closure,:transfer,:my_transactions_statements,:export_statement], :attribute_check => true, :load_method => lambda {BankAccount.find(params[:id])}
  before_filter :search_statement_by_date, :only => [:customer_transactions_statement,:my_transactions_statements,:export_statement_csv]
  before_filter :find_account, 
    :only =>
    [:show,:account_closure,:approve_closure,:suspend_account,:reject_closure,:revert_closure,:transactions_page, :bank_transactions_statement,:beneficiaries_page,:transfer,:destroy]
  def index
    @bank_accounts = BankAccount.all  
  end
  
  def show_bank_accounts
      @bank_accounts = BankAccount.search(params[:name], params[:nationality], params[:account_number])
      if @bank_accounts.present?
        render :update do |page|
              page.replace_html :result, :partial => 'show_bank_accounts', :locals =>{:bank_accounts =>@bank_accounts}
        end
      else
        render :update do |page|
              page.replace_html :result, "<p>No data </p>"
        end
      end  
  end
 
  def show
    
  end
  
  def transactions_page
    @transactions = @bank_account.bank_transactions
    @beneficiaries= @bank_account.beneficiaries.all(:conditions =>["status =?","approved"])
  end
  def bank_transactions_statement
    @transactions = @bank_account.bank_transactions
    @beneficiaries= @bank_account.beneficiaries.all(:conditions =>["status =?","approved"])
  end
  def customer_transactions_statement
    render :update do |page|
         page.replace_html :statements, :partial => 'statements', :locals =>{:transactions =>@transactions}
    end
  end
  
  def my_transactions_statements
    @c=current_user.record_type
   
    render :pdf => "transactions_statement_pdf",
           :template => "bank_accounts/transactions_statement_pdf"
       
  end
  
  def export_statement_csv
   
      statement_csv = FasterCSV.generate do |csv|
      csv <<["Account number :",@bank_account.account_number]
      # header row
      csv << ["Sl.No","Transaction Date","Particulars", "Cr/Dr", "Amount","Balance"]
      
      # data rows
      @transactions.each_with_index do |tran,i|
        csv << [i+1,tran.created_at.strftime("%d-%m-%Y"),tran.particulars,tran.transaction_type,
          tran.transaction_amount, tran.balance]
      end
    end
    send_data(statement_csv, :type => 'text/csv', :filename => 'statements.csv')
  end
  
  def beneficiaries_page
    @beneficiaries= @bank_account.beneficiaries
  end
  
  def withdraw_deposit
    
      @transaction = BankAccount.deposit(params[:amount],params[:id])  if params[:trans_type] == "Deposit"           
   
      @transaction = BankAccount.withdraw(params[:amount],params[:id]) if params[:trans_type] == "Withdraw" 
      
    if @transaction
      flash[:success] = "Transaction  successful"
    else
      flash[:error] = "Transaction  Failed"

    end
      redirect_to :back
  end
      
  def transfer
    @beneficiary_account= @bank_account.beneficiaries.find_by_id(params[:transfer][:to_bank_account])
    @transaction = BankAccount.transfer(params[:id],@beneficiary_account.to_bank_account_id,params[:transfer][:amount])
   
    if @transaction
      flash[:success] = "Transaction  successful"
    else
      flash[:error] = "Transaction  Failed"

    end
      redirect_to :back
  end
  
  def destroy
    @bank_accounts.destroy
    redirect_to bank_accounts_path
  end
  
  def account_closure
  end
  
  def close_requests
    @requests=ClosureRequest.find_by_bank_account_id(params[:close_account_request][:bank_account_id])
   
    if  !@requests.present?
      @closure_request = ClosureRequest.create(params[:close_account_request])
      if @closure_request.save
        flash[:success] = "Request sent"
        redirect_to @closure_request.bank_account
      else
      flash[:error] = "Request not sent"
      end
    else
      flash[:notive] = "Request already sent"
      redirect_to :back

    end  
    
  end
  
  def all_close_account_requests 
    @requests = ClosureRequest.all     
  end
  
  def approve_closure    
    @user = @bank_account.customer.user
    @request = @bank_account.closure_request
    if @request.approval_status == "pending"
      if @request.update_attributes(:approval_status => "Approved") && 
          @bank_account.update_attributes(:active_status => false)  &&
          @user.update_attributes(:is_active => false)
       flash[:success] = "Application approved."
      else
        flash[:error] = "Closure cannot  be done"
      end
    else
       flash[:error] = "Something went wrong"
    end  
    redirect_to :back     
  end
  def reject_closure
    @request = @bank_account.closure_request
    if @request.approval_status == "pending"
      @request.approval_status = "Rejected"
      @request.save
        
      if @request.save
       flash[:success] = "Application rejected."
      else
        flash[:success] = "Closure cannot  be done"
      end
    end
    redirect_to :back

  end
  def revert_closure
    @request = @bank_account.closure_request
    if @request.approval_status != "pending"
      @request.approval_status = "pending"
      @request.save
      @bank_account.active_status = true
      @user = @bank_account.customer.user
      @user.is_active = true
      @bank_account.save
      @user.save
     
      if @bank_account.save && @request.save
       flash[:success] = "Application approved."
      else
        flash[:success] = "Closure cannot  be done"
      end
    end
        redirect_to :back

  end
  
  def suspend_account   
    @user = @bank_account.customer.user
    @bank_account.active_status = false
    @bank_account.save
    if @bank_account.save
      flash[:notice] = "Account suspended"
      redirect_to :back
    end
  end
  def revert_suspend
    @user = @bank_account.customer.user
    @bank_account.active_status = true
    @bank_account.save
    if @bank_account.save
      flash[:notice] = "Account is re activated from suspended mode"
      redirect_to :back
    end
  end
  
  def search
      @bank_accounts = BankAccount.all(
        :joins =>['JOIN customers ON customers.id = bank_accounts.customer_id'],
        :conditions=> ['first_name LIKE ?',"%#{params[:search]}%"])

          respond_to :js
    
  end
   
  private
  
  def search_statement_by_date
    start_params = params[:start_date]
    end_params = params[:end_date]
    @start_date = Date.new(start_params["(1i)"].to_i,start_params["(2i)"].to_i,start_params["(3i)"].to_i)
    @end_date = Date.new(end_params["(1i)"].to_i,end_params["(2i)"].to_i,end_params["(3i)"].to_i)
     if current_user.record == "Customer"
    @bank_account = current_user.record.bank_account
    else
    @bank_account = BankAccount.find(params[:id])
    end
    @transactions = @bank_account.bank_transactions.all(
      :conditions => ['CAST(created_at AS DATE) BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)',@start_date,@end_date])
  end
  def find_account
      @bank_account = BankAccount.find(params[:id])    
  end
end
