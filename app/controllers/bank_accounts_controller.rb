class BankAccountsController < ApplicationController
  filter_access_to :all,  :except => [:show,:customer_transactions_statement,:transactions_page,:bank_transactions_statement,:account_closure,:transfer,:my_transactions_statements,:export_statement_csv]
  filter_access_to [:show,:transactions_page,:customer_transactions_statement,:bank_transactions_statement,:account_closure,:transfer,:my_transactions_statements,:export_statement], :attribute_check => true, :load_method => lambda {BankAccount.find(params[:id])}
  def index
    @bank_accounts = BankAccount.all
    
  end
  def show_bank_accounts
              puts "coming inside 11=================="

      @bank_accounts=[]
      
      if  !params[:name].empty? && !params[:nationality].empty? && 
          !params[:account_number].empty?
        puts "cominh here"
        puts params[:name].nil?
        puts params[:name].empty?
        puts params[:name].present?
        @bank_accounts = BankAccount.all(
          :joins =>['JOIN customers ON customers.id = bank_accounts.customer_id'],
          :conditions=> ['account_number = ? OR first_name LIKE ? OR nationality = ?',
            "#{params[:account_number]}","%#{params[:name]}%",params[:nationality]])
      elsif !params[:name].empty?
        @bank_accounts = BankAccount.all(
          :joins =>['JOIN customers ON customers.id = bank_accounts.customer_id'],
          :conditions=> ['first_name LIKE ?',"%#{params[:name]}%"])
      elsif !params[:nationality].empty?
        @bank_accounts = BankAccount.all(
          :joins =>['JOIN customers ON customers.id = bank_accounts.customer_id'],
          :conditions=> ['nationality = ?',"#{params[:nationality]}"])
       
      elsif !params[:account_number].empty?
                puts "cominh here 5555"

        @bank_accounts = BankAccount.all(
          :joins =>['JOIN customers ON customers.id = bank_accounts.customer_id'],
          :conditions=> ['account_number = ?',"#{params[:account_number]}"])
      else
        flash.now[:notice]= "Input notreceived"        
      end 
          render :update do |page|
              puts "gdfd"
              page.replace_html :result, :partial => 'show_bank_accounts', :locals =>{:bank_accounts =>@bank_accounts}
              puts "gdfd"

          end
              
       
          
  end
 
  def show
    @bank_account = BankAccount.find(params[:id])
    
  end
  
  def transactions_page
    @bank_account = BankAccount.find(params[:id])
    @transactions = @bank_account.bank_transactions
    @beneficiaries= @bank_account.beneficiaries.all(:conditions =>["status =?","approved"])
  end
  def bank_transactions_statement
    @bank_account = BankAccount.find(params[:id])
    @transactions = @bank_account.bank_transactions
    @beneficiaries= @bank_account.beneficiaries.all(:conditions =>["status =?","approved"])
  end
  def customer_transactions_statement
        start_params = params[:start_date]
        end_params = params[:end_date]
          
        start_date = Date.new(start_params["(1i)"].to_i,start_params["(2i)"].to_i,start_params["(3i)"].to_i)
        
        end_date = Date.new(end_params["(1i)"].to_i,end_params["(2i)"].to_i,end_params["(3i)"].to_i)
    puts " coming wohoo"
    if current_user.record == "Customer"
    @bank_account = current_user.record.bank_account
    else
    @bank_account = BankAccount.find(params[:id])
    end
    @transactions = @bank_account.bank_transactions.all(
      :conditions => ['CAST(created_at AS DATE) BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)',start_date,end_date])
     render :update do |page|
              puts "gdfd"
              page.replace_html :statements, :partial => 'statements', :locals =>{:transactions =>@transactions}
              puts "gdfd"
      end
  end
  
  def my_transactions_statements
   start_params = params[:start_date]
   p start_params
   end_params = params[:end_date]
   start_date = Date.new(start_params["(1i)"].to_i,start_params["(2i)"].to_i,start_params["(3i)"].to_i)
   end_date = Date.new(end_params["(1i)"].to_i,end_params["(2i)"].to_i,end_params["(3i)"].to_i)
    if current_user.record_type == "Customer"
    @bank_account = current_user.record.bank_account
    else
    @bank_account = BankAccount.find(params[:id])
    end
    @transactionss = @bank_account.bank_transactions.all(
      :conditions => ['CAST(created_at AS DATE) BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)',start_date,end_date])
    @c=current_user.record_type
    p @c
    render :pdf => "transactions_statement_pdf",
           :template => "bank_accounts/transactions_statement_pdf"
       
  end
  def export_statement_csv
   start_params = params[:start_date]
   end_params = params[:end_date]
   start_date = Date.new(start_params["(1i)"].to_i,start_params["(2i)"].to_i,start_params["(3i)"].to_i)
   end_date = Date.new(end_params["(1i)"].to_i,end_params["(2i)"].to_i,end_params["(3i)"].to_i)
    if current_user.record_type == "Customer"
    @bank_account = current_user.record.bank_account
    else
    @bank_account = BankAccount.find(params[:id])
    end
    @transactionss = @bank_account.bank_transactions.all(
      :conditions => ['CAST(created_at AS DATE) BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)',start_date,end_date])
    statement_csv = FasterCSV.generate do |csv|
      csv <<["Account number :",@bank_account.account_number]
      # header row
      csv << ["Sl.No","Transaction Date","Particulars", "Cr/Dr", "Amount","Balance"]
      
      # data rows
      @transactionss.each_with_index do |tran,i|
        csv << [i+1,tran.created_at,tran.particulars,tran.transaction_type,
          tran.transaction_amount, tran.balance]
      end
    end
   
  send_data(statement_csv, :type => 'text/csv', :filename => 'statements.csv')
  end
  def beneficiaries_page
    @bank_account = BankAccount.find(params[:id])
    @beneficiaries= @bank_account.beneficiaries
    p @beneficiaries
  end
  
  def withdraw_deposit
    if params[:trans_type] == "Deposit"
      @transaction = BankAccount.deposit(params[:amount],params[:id])             
    else    
      @transaction = BankAccount.withdraw(params[:amount],params[:id])
    end  
    p @transaction
    if @transaction
      flash[:success] = "Transaction  successful"
    else
      flash[:error] = "Transaction  Failed"

    end
      redirect_to :back
  end
    
  
  def transfer
    @bank_account= BankAccount.find(params[:id])
    p params[:transfer][:to_bank_account_id]
    @beneficiary_account= @bank_account.beneficiaries.find_by_id(params[:transfer][:to_bank_account])
    @transaction = BankAccount.transfer(params[:id],@beneficiary_account.to_bank_account_id,params[:transfer][:amount])
    p "TRANS__"
    p @transaction 
    if @transaction
      flash[:success] = "Transaction  successful"
    else
      flash[:error] = "Transaction  Failed"

    end
          redirect_to :back
  end
  
  def destroy
    @bank_accounts = BankAccount.find(params[:id])
    @bank_accounts.destroy
    redirect_to bank_accounts_path
  end
  
  def account_closure
    @bank_account = BankAccount.find(params[:id])
    
  end
  
  
  
  def close_requests
    @requests=ClosureRequest.find_by_bank_account_id(params[:close_account_request][:bank_account_id])
    
    if  !@requests.present?
      @closure_request = ClosureRequest.create(params[:close_account_request])
      if @closure_request.save
      flash[:success] = "Request sent"
      redirect_to :back
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
    
    @bank_account = BankAccount.find(params[:id])
    @request = @bank_account.closure_request
    if @request.approval_status == "pending"
      @request.approval_status = "Approved"
      @bank_account.active_status = false
      @user = @bank_account.customer.user
      @user.is_active = false
      @request.save
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
  def reject_closure
    @bank_account = BankAccount.find(params[:id])
    @request = @bank_account.closure_request
    if @request.approval_status == "pending"
      @request.approval_status = "Rejected"
      @request.save
        
      if @request.save
       flash[:success] = "Application approved."
      else
        flash[:success] = "Closure cannot  be done"
      end
    end
        redirect_to :back

  end
  def revert_closure
    @bank_account = BankAccount.find(params[:id])
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
    
    @bank_account = BankAccount.find(params[:id])
    @user = @bank_account.customer.user
    @bank_account.active_status = false
    @bank_account.save
    if @bank_account.save
      flash[:notice] = "Account suspended"
      redirect_to :back
    end
  end
  def revert_suspend
    @bank_account = BankAccount.find(params[:id])
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
  
  def update 
    
  end

end
