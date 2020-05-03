Rails.application.routes.draw do

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :home_search
  get 'employees/search', to: 'employees#search', as: :employee_search
  
  get 'stores/:id/payroll', to: 'payrolls#get_store_form', as: :store_form
  get 'payrolls', to: 'payrolls#calculate_stores', as: :calculate_stores

  get 'payrolls/info', to: 'payrolls#info', as: :payroll_info

  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :employees
  resources :stores
  resources :assignments
  resources :users
  resources :sessions
  resources :shifts
  resources :pay_grades
  resources :pay_grade_rates
  resources :jobs
  resources :shift_jobs 


  # Custom routes
  patch 'assignments/:id/terminate', to: 'assignments#terminate', as: :terminate_assignment
  patch 'shifts/:id/clockin', to: 'shifts#clockin', as: :clock_in_shift
  patch 'shifts/:id/clockout', to: 'shifts#clockout', as: :clock_out_shift

  # You can have the root of your site routed with 'root'
  root 'home#index'


  get 'employee/edit' => 'employees#edit', :as => :edit_current_user
  get 'signup' => 'employee#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout


end

