class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy, :clockin, :clockout, :get_current_jobs_for_shift]

  # GET /shifts
  # GET /shifts.json
  def index
    
    @fourteen_day_range = DateRange.new(1.week.ago.to_date, 1.week.from_now.to_date)
    if current_user.role? :admin
      @all_shifts = Shift.all.paginate(page: params[:page]).per_page(5)
      @upcoming_shifts = Shift.upcoming.for_dates(@fourteen_day_range).by_store.chronological.by_employee.paginate(page: params[:page]).per_page(5)
      @past_shifts = Shift.past.completed.for_dates(@fourteen_day_range).by_store.by_employee.chronological.paginate(page: params[:page]).per_page(5)
      @completed_shifts = Shift.completed.by_store.by_employee.chronological.paginate(page: params[:page]).per_page(5)
      @pending_shifts = Shift.pending.by_store.by_employee.chronological.paginate(page: params[:page]).per_page(5)

    elsif current_user.role? :manager
      @all_shifts = Shift.all.paginate(page: params[:page]).per_page(10)
      @upcoming_shifts = Shift.upcoming.for_store(current_user.current_assignment.store).chronological.by_employee.paginate(page: params[:page]).per_page(5)
      @past_shifts = Shift.past.finished.for_store(current_user.current_assignment.store).chronological.by_employee.paginate(page: params[:page]).per_page(5)
      @completed_shifts = Shift.completed.for_past_days(7).by_store.by_employee.chronological.paginate(page: params[:page]).per_page(5)
      @pending_shifts = Shift.pending.for_next_days(7).by_store.by_employee.chronological.paginate(page: params[:page]).per_page(5)
    elsif current_user.role? :employee
      #upcoming shifts for next 7 days 
      @upcoming_shifts  = Shift.upcoming.for_employee(current_user).chronological.paginate(page: params[:page]).per_page(8)
      @past_shifts = Shift.past.for_employee(current_user).by_employee.chronological.paginate(page: params[:page]).per_page(8)
      @completed_shifts = Shift.completed.for_employee(current_user).chronological.by_employee.paginate(page: params[:page]).per_page(5)
      @pending_shifts = Shift.pending.for_employee(current_user).chronological.by_employee.paginate(page: params[:page]).per_page(5)

      today_date_range = DateRange.new(Date.today.to_date, Date.tomorrow.to_date)
      @pending_shifts_for_today = Shift.chronological.for_employee(current_user).for_dates(today_date_range).paginate(page: params[:page]).per_page(5)
    end

    # if params[:status] == 'upcoming'
    #   @shifts = @upcoming_shifts
    #   @state = 'upcoming'
    # elsif params[:status] == 'past'
    #   @shifts = @past_shifts
    #   @state = 'past'
    # end 


    

  end

  # GET /shifts/1
  # GET /shifts/1.json
  def show
    get_current_jobs_for_shift
  end

  # GET /shifts/new
  def new
    @shift = Shift.new
    
  end

  # GET /shifts/1/edit
  def edit
  end

  # POST /shifts
  # POST /shifts.json
  def create
    @shift = Shift.new(shift_params)
    
    if @shift.save
      redirect_to shifts_path, notice: "Shift created for #{@shift.assignment.employee.proper_name} at #{@shift.assignment.store.name}."
    else
      render action: 'new'
    end
    
  end

  def clockin
      @time_clock1 = TimeClock.new(@shift)
      @time_clock1.start_shift_at(Time.now)
      @shift.reload
      @shift.status = 'started'
      redirect_to home_path, notice: "Shift for #{@shift.start_time.strftime( "%I:%M %p")} has begun"
  end


  def get_current_jobs_for_shift
      @current_jobs = ShiftJob.for_shift(@shift)
  end



  # PATCH/PUT /shifts/1
  # PATCH/PUT /shifts/1.json
  def update
    if @shift.update(shift_params)
      redirect_to home_path, notice: "#{@shift.assignment.employee.proper_name}'s shift at #{@shift.assignment.store.name} is updated."
    else
      render action: 'edit'
    end
  end

  # DELETE /shifts/1
  # DELETE /shifts/1.json
  def destroy
    @shift.destroy
    respond_to do |format|
      format.html { redirect_to shifts_url, notice: 'Shift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  

  def clockout
      @time_clock2 = TimeClock.new(@shift)
      @time_clock2.end_shift_at(Time.now)
      @shift.reload
      @shift.status = 'finished'
      redirect_to home_path, notice: "Shift has been clocked out"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shift_params
      params.require(:shift).permit(:date, :start_time, :end_time, :notes, :status, :assignment_id)
    end

    
end