authorization do
  role :admin do
     includes :manage_users
     includes :manage_customers
     includes :manage_employees
     includes :manage_bank_accounts
      
  end
  role :guest do
      has_permission_on :customers, :to => [:new,:create,:check_application_status,:show_application_status]
      has_permission_on :employees, :to => [:new,:create]
      
  end
  role :customer do
    has_permission_on :customers, :to =>[:show, :edit,:update,:beneficiaries,:create_beneficiary] do
      if_attribute :id => is {user.record_id}
    end
    has_permission_on :bank_accounts, :to =>[:customer_transactions_statement,:show,:transactions_page,:bank_transactions_statement,:account_closure,:close_requests,:beneficiaries_page,:transfer,:my_transactions_statements,:export_statement_csv] do
      if_attribute :customer_id => is {user.record_id}
    end
  end
    
  
  role :employee do
      has_permission_on :employees,:to =>[:show]
      has_permission_on :employees, :to =>[:edit,:update] do
        if_attribute :id => is {user.record_id}
      end
      
      has_permission_on :bank_accounts, :to =>[:index,:show,:customer_transactions_statement,:my_transactions_statements,:show_bank_accounts ,:withdraw_deposit,:transfer,:transactions_page,:export_statement_csv]
  end
 
  role :manage_users do
    has_permission_on :users, :to => [:index,:edit,:new,:create, :update,:show,:destroy]
  end
  role :manage_customers do
    has_permission_on :customers, :to => [:index, :new, :create, :check_application_status,:show_application_status,:approve,:reject,:revert,:approve_reject_beneficiaries,:edit,:show, :update,:destroy]
  end
  role :manage_employees do
    has_permission_on :employees, :to => [:index, :new,:edit,:update, :create, :show, :update,:destroy]
  end
  role :manage_bank_accounts do
    has_permission_on :bank_accounts, :to => [:index,:my_transactions_statements,:new,:create,:export_statement_csv,:update,:edit,:destroy,:beneficiaries_page,:approve_closure,:all_close_account_requests,:reject_closure,:revert_closure,:suspend_account,:revert_suspend,:beneficiaries,:customer_transactions_statement,:show_bank_accounts ,:withdraw_deposit,:transfer,:transactions_page,:index, :new, :create, :show, :update,:destroy]
  end
 
   
end