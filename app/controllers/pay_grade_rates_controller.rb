class PayGradeRatesController < ApplicationController
  before_action :set_pay_grade_rate, only: [:show, :edit, :update, :destroy]

  # GET /pay_grade_rates
  # GET /pay_grade_rates.json
  def index
    @pay_grade_rates = PayGradeRate.all


  end

  # GET /pay_grade_rates/1
  # GET /pay_grade_rates/1.json
  def show
  end

  # GET /pay_grade_rates/new
  def new
    @pay_grade_rate = PayGradeRate.new
  end

  # GET /pay_grade_rates/1/edit
  def edit
  end

  # POST /pay_grade_rates
  # POST /pay_grade_rates.json
  def create
    @pay_grade_rate = PayGradeRate.new(pay_grade_rate_params)
    if @pay_grade_rate.save
      redirect_to pay_grades_path, notice: "Successfully added the paygrade rate."
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /pay_grade_rates/1
  # PATCH/PUT /pay_grade_rates/1.json
  def update
    respond_to do |format|
      if @pay_grade_rate.update(pay_grade_rate_params)
        format.html { redirect_to @pay_grade_rate, notice: 'Pay grade rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @pay_grade_rate }
      else
        format.html { render :edit }
        format.json { render json: @pay_grade_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pay_grade_rates/1
  # DELETE /pay_grade_rates/1.json
  def destroy
    @pay_grade_rate.destroy
    respond_to do |format|
      format.html { redirect_to pay_grade_rates_url, notice: 'Pay grade rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pay_grade_rate
      @pay_grade_rate = PayGradeRate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pay_grade_rate_params
      params.require(:pay_grade_rate).permit(:rate, :start_date, :end_date, :pay_grade_id)
    end
end