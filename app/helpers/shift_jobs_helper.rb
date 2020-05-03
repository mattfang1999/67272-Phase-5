module ShiftJobsHelper
	
	
	def get_shift_options
		Shift.by_id.map{|s| ["Shift #{s.id}", s.id]}
	end

	def get_job_options
		Job.alphabetical.map{|j| ["#{j.name}", j.id]}
	end 
end