class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy, :retrieve_employee_payroll, :retrieve_employee_shifts]

  def index
    # for phase 3 only

    if current_user.role?(:admin)
    @active_managers = Employee.managers.active.alphabetical.paginate(page: params[:man_page]).per_page(10)
    @active_employees = Employee.regulars.active.alphabetical.paginate(page: params[:emp_page]).per_page(10)
    @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:in_page]).per_page(10)
    elsif current_user.role?(:manager)
    @active_managers = Employee.for_store(current_user.current_assignment.store_id).managers.active.alphabetical.paginate(page: params[:page]).per_page(6)
    @active_employees = Employee.regulars.for_store(current_user.current_assignment.store_id).active.alphabetical.paginate(page: params[:page]).per_page(6)
    @inactive_employees = Employee.for_store(current_user.current_assignment.store_id).inactive.alphabetical.paginate(page: params[:page]).per_page(6)
    end

    retrieve_employee_payroll
    # retrieve_employee_shifts
    @stores = Store.all

  end

  def show
    retrieve_employee_assignments
    retrieve_employee_shifts
    retrieve_employee_payroll
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to @employee, notice: "Successfully added #{@employee.proper_name} as an employee."
    else
      render action: 'new'
    end
  end

  def update
    if @employee.update_attributes(employee_params)
      redirect_to @employee, notice: "Updated #{@employee.proper_name}'s information."
    else
      render action: 'edit'
    end
  end


  def destroy

    if @employee.destroy
      @employee.destroy
      respond_to do |format|
        format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      @employee.active == false
      redirect_to @employee, notice: "Cannot destroy an employee who has worked more than one shift. Will be made inactive instead."
    end
  end


    def search
      redirect_back(fallback_location: employee_path) if params[:query].blank?
      @query = params[:query]
      @employees = Employee.search(@query)
      @total_hits = @employees.size 
    end

     def retrieve_employee_shifts

      @upcoming_shifts_in_7 = Shift.upcoming.for_next_days(7).by_store.by_employee.for_employee(current_user).paginate(page: params[:page]).per_page(5)

      if (current_user.role?(:admin)|| current_user.role?(:manager))
        date_range = DateRange.new(7.days.ago.to_date, 7.days.from_now.to_date)
        @past_shifts = Shift.past.by_store.by_employee.for_past_days(7).for_employee(@employee).paginate(page: params[:page]).per_page(5)
        @pending_shifts = Shift.pending.by_store.by_employee.for_dates(date_range).for_employee(@employee).paginate(page: params[:page]).per_page(5)
        @completed_shifts = Shift.completed.by_store.by_employee.for_dates(date_range).for_employee(@employee).paginate(page: params[:page]).per_page(5)
      else
        date_range = DateRange.new(7.days.ago.to_date, 7.days.from_now.to_date)
        @past_shifts = Shift.past.by_store.by_employee.for_past_days(7).for_employee(current_user).paginate(page: params[:page]).per_page(5)
        @pending_shifts = Shift.pending.by_store.by_employee.for_dates(date_range).for_employee(current_user).paginate(page: params[:page]).per_page(5)
        @past_shifts = Shift.past.by_store.by_employee.for_employee(current_user).paginate(page: params[:page]).per_page(5)
        @completed_shifts = Shift.completed.for_employee(current_user).by_employee.paginate(page: params[:page]).per_page(5)
        

      end
      # @past_shifts = Shift.past.by_store.by_employee.for_employee(current_user).paginate(page: params[:page]).per_page(5)
      # @completed_shifts = Shift.completed.for_employee(current_user).by_employee.paginate(page: params[:page]).per_page(5)
      # @pending_shifts = Shift.pending.for_employee(current_user).by_employee.paginate(page: params[:page]).per_page(5)
      if !current_user.current_assignment.nil?
        @finished_shifts_for_manager_store= Shift.finished.for_store(current_user.current_assignment.store).by_employee.paginate(page: params[:page]).per_page(5)
      end


  end

   def retrieve_employee_payroll
     @calculator = PayrollCalculator.new(DateRange.new(7.days.ago.to_date, Date.current.to_date))  
     @seven_days_employee_payroll_record = @calculator.create_payroll_record_for(current_user)

     @calculator2 = PayrollCalculator.new(DateRange.new(14.days.ago.to_date, Date.current.to_date))  
     @half_month_employee_payroll_record = @calculator2.create_payroll_record_for(current_user)

     @calculator3 = PayrollCalculator.new(DateRange.new(1.month.ago.to_date, Date.current.to_date))  
     @monthly_employee_payroll_record = @calculator3.create_payroll_record_for(current_user)
  end

  def retrieve_employees_at_manager_store
      @employees_at_manager_store = Shift.for_store(current_user.current_assignment.store).employees.proper_name
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :phone, :date_of_birth, :role, :active, :username, :password, :password_confirmation)
  end

  def retrieve_employee_assignments
    @current_assignment = @employee.current_assignment
    @previous_assignments = @employee.assignments.to_a - [@current_assignment]
  end



 



end
