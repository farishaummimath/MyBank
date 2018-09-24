Gretel::Crumbs.layout do
  crumb :root do
    link "Home", {:controller => "pages", :action => "home"}
  end
   
  crumb :customers_index do
    link "Customers", {:controller => "customers", :action => "index"}
    parent :root
  end
  crumb :customers_show do
    link "Customer profile", {:controller => "customers", :action => "show"}
    parent :customers_index
  end
  
  crumb :employees_index do
    link "Employees", {:controller => "employees", :action => "index"}
    parent :root
  end
  crumb :employees_show do
    link "Employee profile", {:controller => "employees", :action => "show"}
    parent :employees_index
  end
  crumb :employees_edit do
    link "Edit employee profile", {:controller => "employees", :action => "edit"}
    parent :employees_show
  end
  crumb :employees_update do
    link "Employee profile", {:controller => "employees", :action => "edit"}
    parent :employees_show
  end
  
  crumb :employees_new do
    link "Add Employees", {:controller => "employees", :action => "new"}
    parent :employees_index
  end
  crumb :employees_create do
    link "Add Employees", {:controller => "employees", :action => "create"}
    parent :employees_index
  end
  crumb :bank_accounts_index do
    link "Bank Accounts", {:controller => "bank_accounts", :action => "index"}
    parent :root
  end
  crumb :bank_accounts_show do
    link "View Account details", {:controller => "bank_accounts", :action => "show"}
    parent :bank_accounts_index
  end
  crumb :bank_accounts_all_close_account_requests do
    link " Account Closure Requests", {:controller => "bank_accounts", :action => "all_close_account_requests"}
    parent :bank_accounts_index
  end
  crumb :bank_accounts_transactions_page do
    link " Transactions and statements", {:controller => "bank_accounts", :action => "transactions_page"}
    parent :bank_accounts_show
  end
  crumb :customers_beneficiaries do
    link " Manage beneficiaries", {:controller => "customers", :action => "beneficiaries"}
    parent :root
  end
  crumb :bank_accounts_beneficiaries_page do
    link "Beneficiaries Request", {:controller => "customers", :action => "beneficiaries_page"}
    parent :bank_accounts_show
  end
  
  
 end