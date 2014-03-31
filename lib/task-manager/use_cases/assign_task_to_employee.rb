module TM
  class AssignTaskToEmployee < UseCase
    def run(inputs)

      task = TM.db.get_task(inputs[:tid])
      return failure(:task_does_not_exist) if task.nil?

      emp = TM.db.get_emp(inputs[:eid])
      return failure(:employee_does_not_exist) if emp.nil?

      # additionally, a task should not be assigned to employee if
      # they are not participating in the task's project
      # add this functionality later
      TM.db.assign_task_to_emp(task.id, emp.id)

      success(:employee => emp, :task => task)
    end
  end
end