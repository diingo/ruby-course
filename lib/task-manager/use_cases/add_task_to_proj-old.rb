module TM
  class AddTaskToProj < UseCase

    def run(inputs)

      if !validate_project(inputs)
        return failer :invalid_project
      end

      proj = db.get_proj(inputs[:pid])

      # Task can only be assigned to project if project exists
      task = TM.db.create_task(proj.id, inputs[:desc], inputs[:priority])
      task.proj_id = proj.id

      success :task => task, :proj => proj
    end

    def validate_project(inputs)
      pid = inputs[:pid]

      proj = db.projects[pid]
    end

    def db
      TM.db
    end
  end
end