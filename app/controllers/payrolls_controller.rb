require 'date'
require 'will_paginate/array'

class PayrollsController < ApplicationController




	def new

	end

	def create
	  # we need a calculator to creeate the payroll 
	end


	def get_store_form
		@store = Store.find(params[:id])
	end


	def calculate_stores
		unless params[:set_start] == "0"
			x = params[:set_start].to_i
			start_date = x.days.ago.to_date
			end_date = Date.current
		else
			start_date = date_parser(params[:starting])
			end_date = date_parser(params[:ending])
		end

		@store = Store.find(params[:store_id])
		@store_date_range = DateRange.new(start_date, end_date)
		calc = PayrollCalculator.new(@store_date_range)
		@payrolls = calc.create_payrolls_for(@store).paginate(page: params[:page], :per_page => 10)
	end



	def info

		#biweekly store payroll for manager
		@store = current_user.current_assignment.store
		@bi_date_range = DateRange.new(2.weeks.ago.to_date)
		calc1 = PayrollCalculator.new(@bi_date_range)

		@month_date_range = DateRange.new(4.weeks.ago.to_date)
		calc2 = PayrollCalculator.new(@month_date_range)


		@biweekly_store_payroll = calc1.create_payrolls_for(@store).paginate(page: params[:page], :per_page => 10)
		@month_store_payroll = calc2.create_payrolls_for(@store).paginate(page: params[:page], :per_page => 10)

	end

	def date_parser(date)
 		Date.strptime(date, "%m/%d/%Y")
	end

	def emp_payroll_info
		@calculator = PayrollCalculator.new(DateRange.new(7.days.ago.to_date, Date.current.to_date))  
     	@seven_days_employee_payroll_record = @calculator.create_payroll_record_for(current_user)

     	@calculator2 = PayrollCalculator.new(DateRange.new(14.days.ago.to_date, Date.current.to_date))  
     	@half_month_employee_payroll_record = @calculator2.create_payroll_record_for(current_user)

     	@calculator3 = PayrollCalculator.new(DateRange.new(1.month.ago.to_date, Date.current.to_date))  
     	@monthly_employee_payroll_record = @calculator3.create_payroll_record_for(current_user)
	end



end
