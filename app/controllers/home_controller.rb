class HomeController < ApplicationController
  def index
  	
  	if current_user != nil
  		retrieve_employee_payroll
  		retrieve_employees_at_manager_store
  		retrieve_employee_shifts
      retrieve_stores_with_no_shows
      get_young_people
  		
  	end

    @stores = Store.all.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def about
  end



  def contact
  end

  def privacy
  end

  def search
      redirect_back(fallback_location: employee_path) if params[:query].blank?
      @query = params[:query]
      @employees = Employee.search(@query)
      @total_hits = @employees.size
      if @total_hits == 1
      	redirect_to Employee.search(@query).first
      end
  end

  def store_calc
		sd = params[:start_date]
		ed = params[:end_date]
		store = Store.find(params[:store_id])
		date_range = DateRange.new(sd, ed)
		calc = PayrollCalculator.new(date_range)

		@store_payroll = calc.create_payrolls_for(store)
		#display in a store_calc template
	end

   def store_pay_form
    @stores = Store.all
    @store = Store.find(params[:id])
  end


  def retrieve_store_payrolls
  	   @stores = Store.all
  	   @calculator_1 = PayrollCalculator.new(DateRange.new(14.days.ago.to_date, Date.current.to_date))
  	   @calculator_2 = PayrollCalculator.new(DateRange.new(14.days.ago.to_date, Date.current.to_date))
  end 


  def retrieve_stores_with_no_shows
      # @no_show_stores = Store.all.paginate(page: params[:page]).per_page(10)

      
      @no_show_stores = Store.all.paginate(page: params[:page]).per_page(10)

      # stores = Store.all.map{|s| s.id }
      
      # store.shifts.pending.finished.count

  end

  def get_young_people
        @young_people = Employee.younger_than_18.alphabetical.active
  end

 


    def generate_payroll
    sd = params[:start_date]
    ed = params[:end_date]
    store = Store.find(params[:store_id])
    date_range = DateRange.new(sd, ed)
    calc = PayrollCalculator.new(date_range)

    @store_payroll = calc.create_payrolls_for(store)
    #display in a store_calc template
  end



  def generate_payroll_calculators
  end

  # @total_no_show_shifts = Shift.pending.past
  # # For each store, count how many no show shifts there are


  def retrieve_employee_payroll
     @calculator = PayrollCalculator.new(DateRange.new(7.days.ago.to_date, Date.current.to_date))  
     @employee_payroll_record = @calculator.create_payroll_record_for(current_user)
  end

  def retrieve_employees_at_manager_store
  	  if current_user.current_assignment != nil
      	@employees_at_manager_store = Employee.for_store(current_user.current_assignment.store_id).active.alphabetical.paginate(page: params[:page]).per_page(10)
      end
  end

  def retrieve_employee_shifts

      @upcoming_shifts_in_7 = Shift.upcoming.for_next_days(7).by_store.by_employee.for_employee(current_user).paginate(page: params[:page]).per_page(5)
      @past_shifts = Shift.past.by_store.by_employee.for_employee(current_user).paginate(page: params[:page]).per_page(5)
      @completed_shifts = Shift.completed.for_employee(current_user).by_employee.paginate(page: params[:page]).per_page(5)
      @pending_shifts = Shift.pending.for_employee(current_user).by_employee.paginate(page: params[:page]).per_page(5)
      if !current_user.current_assignment.nil?
        @finished_shifts_for_manager_store= Shift.finished.for_store(current_user.current_assignment.store).by_employee.paginate(page: params[:page]).per_page(5)
        @no_show_shifts = Shift.pending.past.for_store(current_user.current_assignment.store).by_employee.paginate(page: params[:page]).per_page(5)
      end
      

  end
  
end