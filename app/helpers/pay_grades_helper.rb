module PayGradesHelper
	
	def get_pay_grade_options
		PayGrade.alphabetical.map{|p| ["Paygrade #{p.level}", p.id]}
	end
end