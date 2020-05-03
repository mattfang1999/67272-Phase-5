# frozen_string_literal: true
#
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    #difference between read and show
    #Read - show + index
    #show - just show 

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      if user.role? :admin
        can :manage, :all

      #PRIVILEGES FOR MANAGER
      elsif user.role? :manager
        #Can manage shifts and jobs
        can :manage, Shift
        can :manage, ShiftJob
        can :manage, Payroll

        #STORES
        #can read the list of stores
        can :index, Store
        #managers can only see the store details they are associated with
        can :show, Store do |this_store|
          my_store = user.stores.map(&:id)
          my_store.include? this_store.id
        end 

        #ASSIGNMENTS
        #can look at a list of all assignments
        can :index, Assignment
        #can only look at employee assignments associated with manager's store
        can :show, Assignment do |this_assignment|
          my_emp_assignments = user.assignments.map(&:store_id)
          my_emp_assignments.include? this_assignment.store_id
        end

        #EMPLOYEES
        #can look at a list of all employees
        can :index, Employee
        #can read their own data
        can :show, user do |u|  
          u.id == user.id
        end

        #can only look at employees associated with manager's store
        can :show, Employee do |this_employee|
          my_emp_store = user.assignments.map(&:store_id)
          my_emp_store.include? this_employee.current_assignment.store_id
        end
        # can only edit employees associated with manager's store
        can :edit, Employee do |this_employee|
          my_emp_store = user.assignments.map(&:store_id)
          my_emp_store.include? this_employee.current_assignment.store_id
        end
        # can only update employees associated with manager's store
        can :update, Employee do |this_employee|
          my_emp_store = user.assignments.map(&:store_id)

         
          my_emp_store.include? this_employee.current_assignment.store_id
        end

        #EMPLOYEE PRIVILEBES
      elsif user.role? :employee

        #ASSIGNMEENTS
        #Can view a list of assignments
        can :index, Assignment
        #Can view his/her own assignment 
        can :show, Assignment do |this_assignment|  
          my_assignment = user.assignments.map(&:id)
          my_assignment.include? this_assignment.id
        end

        #EMPLOYEES
        #Can only view his/her own profile
        can :show, user do |u|
          u.id == user.id
        end
        #Can only edit themselves 
        can :edit, user do |u|
          u.id == user.id
        end
        #Can only update themselves
        can :update, user do |u|
          u.id == user.id
        end

        


      #Guests can only read stores 
      else
        can :read, Store
      end
    
  end
end
