ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  map.resources :users , :collection => {:login => [:get]}
  map.resources :customers, :member => {:check_application_status => [:get],
    :approve => [:get],:reject => [:get],:revert => [:get],
    :show_application_status => [:get],:beneficiaries => [:get],:create_beneficiary => [:post],:approve_reject_beneficiaries =>[:post]}
  map.resources :employees
  map.resources :bank_accounts, 
    :member => {:customer_transactions_statement => [:post],:search =>[:get],:withdraw_deposit => [:post],
    :transfer => [:post],:account_closure => [:get],:close_account=>[:post],
    :transactions_page =>[:get],:transactions_statement_pdf=>[:get],:beneficiaries_page => [:get],:approve_closure=>[:get],
    :reject_closure => [:get],:revert_closure => [:get],:suspend_account => [:get],:revert_suspend =>[:get]},
    :collection => {:my_transactions_statements => [:get],:export_statement_csv=>[:get],:show_bank_accounts => [:get],:close_requests => [:get],:all_close_account_requests => [:get]}
  
  map.application_status '/application_status', :controller => 'customers', :action => "check_application_status"
  map.view_status '/view_status', :controller => 'customers', :action => "show_application_status"
  map.login_page '/login_page', :controller => 'users', :action => 'login_page'
  map.logout  '/logout', :controller => 'users', :action => 'logout'
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "pages",:action =>"home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
