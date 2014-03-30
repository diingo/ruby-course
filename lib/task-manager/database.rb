module TM
  # Our singleton getter
  def self.db
    @__db_instance ||= DB.new
  end

  class DB
    attr_reader :projects, :tasks, :employees

    def initialize
      @projects = {}
      @tasks = {}
      @employees = {}
      @memberships = []
    end

    #######################################################
    # Getters for tasks, projects, employees, memberships #
    #######################################################

    def all_tasks
      @tasks.values
    end

    def all_projects
      @projects.values
    end

    def all_employees
      @employees.values
    end

    def all_memberships
      @memberships
    end

    #######################
    ## Task CRUD Methods ##
    #######################

    # this is the same as add_task_to_proj
    # add_task_to_proj will later be moved to a use case
    def create_task(pid, desc, priority)
      pid = pid.to_i
      priority = priority.to_i

      if @projects[pid]
        task = TM::Task.new(pid, desc,priority)
        task_id = task.id

        @tasks[task_id] = task

        task
      end
    end

    def get_task(tid)
      tid = tid.to_i

      @tasks[tid]
    end

    def update_task(tid, new_description = nil, new_priority = nil)
      tid = tid.to_i
      task = @tasks[tid]

      task.description = new_description || task.description

      task.priority = new_priority || task.priority
    end

    def delete(tid)
      tid = tid.to_i
      @tasks.delete(tid)
    end

    ##########################
    ## Project CRUD Methods ##
    ##########################

    def create_proj(title)
      proj = TM::Project.new(title)
      proj_id = proj.id

      @projects[proj_id] = proj

      proj
    end

    def get_proj(pid)
      pid = pid.to_i

      @projects[pid]
    end

    def update_proj(pid, new_name = nil)
      pid = pid.to_i

      proj = @projects[pid]
      proj.name = new_name || proj.name
    end

    def delete_proj(pid)
      pid = pid.to_i

      @projects.delete(pid)
    end

    ###########################
    ## Employee CRUD Methods ##
    ###########################

    def create_emp(name)
      emp = TM::Employee.new(name)
      @employees[emp.id] = emp
      emp
    end

    def get_emp(eid)
      eid = eid.to_i

      @employees[eid]
    end

    def update_emp(eid, new_name)
      eid = eid.to_i

      emp = @employees[eid]
      emp.name = new_name
      emp
    end

    def delete_emp(eid)
      eid = eid.to_i

      @employees.delete(eid)
    end

    ####################
    ## Client Queries ##
    ####################

    def show_proj_tasks_remaining(pid)
      # ensure id is an integer
      pid = pid.to_i

      # array of tasks belonging to this pid
      # @tasks.values creates an array from values in @tasks hash
      pid_tasks = @tasks.values.select { |task| task.proj_id == pid }

      incomplete_tasks = pid_tasks.select do |task|
        task.completed == false
      end
    end

    def show_proj_tasks_complete(pid)
      # ensure id is an integer
      pid = pid.to_i

      pid_tasks = @tasks.values.select { |task| task.proj_id == pid }

      completed_tasks = pid_tasks.select { |task| task.completed == true }
    end

    def show_emp_projs(eid)
      emp_hashes_arr = @memberships.select { |memb| memb[:eid] == eid }
      projs_of_emp_hashes_arr = emp_hashes_arr.map { |memb| @projects[memb[:pid]]}
    end

    def show_proj_participants(pid)
      proj_hashes_arr = @memberships.select { |memb| memb[:pid] == pid }
      emps_of_proj_hashes_arr = proj_hashes_arr.map { |memb| @employees[memb[:eid]] }
    end
    
    #####################
    ## Client Commands ##
    #####################

    def mark_task_as_complete(tid)
      # ensure id is an integer
      tid = tid.to_i

      @tasks[tid].completed = true

      @tasks[tid]
    end

    def add_emp_to_proj(pid, eid)
      @memberships << { pid: pid, eid: eid }
      @employees[eid]
    end


  end

end

