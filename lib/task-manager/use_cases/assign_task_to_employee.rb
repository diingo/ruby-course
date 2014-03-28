module TM
  class AssignTaskToEmployee < UseCase

    def run(inputs)

      if !validate_task(inputs)
        return failure :invalid_task
      end

      if !validate_employee(inputs)
        return failure :invalid_employee
      end

      task = TM.db.get_task(inputs[:tid])
      emp = TM.db.get_emp(inputs[:eid])

      add_employee_to_task(emp, task)

      success :task => task, :get_employee => emp
    end

    def validate_task(inputs)
      tid = inputs[:tid]
      task = TM.db.tasks[tid]
      task && task.completed == false

      # old version
      # task && task.completed == false && task.eid == nil
    end

    def validate_employee(inputs)
      eid = inputs[:eid]
      emp = TM.db.employees[eid]
      emp
    end

    def add_employee_to_task(emp, task)
      task.eid = emp.id
    end
  end
end