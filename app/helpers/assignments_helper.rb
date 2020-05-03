module AssignmentsHelper
	
	def get_assignment_options

		Assignment.current.by_store.by_employee.chronological.map{|a| ["#{a.employee.name} @ #{a.store.name}", a.id]}
	end
end



    


