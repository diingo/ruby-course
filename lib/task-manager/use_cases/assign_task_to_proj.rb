module TM
  class AssignTaskToProject < UseCase

    def run(inputs)
      if inputs[:desc].nil?
        return failure(:missing_task_name)
      end

      project = TM.db.get_project(inputs[:project_id])
      return failure(:missing_project) if project.nil?

      inputs[:priority] ||= 10
      add_task_to_proj(inputs[:project_id], inputs[:desc], inputs[:priority])


      add_task_to_proj(inputs[:project_id], inputs[:desc], inputs[:priority])
    end

    def assign_task_to_proj
      TM.db.create_task(pid, desc, priority)
    end
  end
end