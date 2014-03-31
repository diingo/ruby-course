require_relative 'lib/task-manager.rb'

# a * next to client command means it was tested in termainl
# a X next to client command means a method was created but not tested in terminal
TERMINAL_PROMPT = <<-eos
Welcome to Project Manager Pro®. What can I do for you today?

Available Commands:
  *help - Show these commands again
  *project list - List all projects
  *project create NAME - Create a new project
  xproject show PID - Show remaining tasks for project PID
  xproject history PID - Show completed tasks for project PID
  xproject employees PID - Show employees participating in this project
  *project recruit PID EID - Adds employee EID to participate in project PID
  *task create PID PRIORITY DESC - Add a new task to project PID
  *task assign TID EID - Assign task TID to employee EID
  xtask mark TID - Mark task TID as complete
  xemp list - List all employees
  *emp create NAME - Create a new employee
  xemp show EID - Show employee EID and all participating projects
  xemp details EID - Show all remaining tasks assigned to employee EID,
                    along with the project name next to each task
  xemp history EID - Show completed tasks for employee with id=EID
eos

class TM::TerminalClient
  def start
    print " > "
    input = gets.chomp
    # binding.pry
    # Example input: task create 12 3 some description stuff
    split = input.split(' ')

    model = split.shift # e.g. project, task, emp
    action = split.shift # e.g. list, create, show, history, etc
    args = split # The rest of the arguments, since .split modifies the array
    if model == "help"
      start
    else
      self.send("#{model}_#{action}", *args)
      start
    end
  end

  def project_list
    TM.db.all_projects.each do |proj|
      puts proj.name
    end
  end

  def project_create(*name)

    name = name.join(" ")
    created_proj = TM.db.create_proj(name)
    puts "Created a new project: "
    puts "PID  Name"
    puts "  #{created_proj.id}   #{created_proj.name}"
  end

  def project_show(pid)
    pid = pid.to_i

    proj = TM.db.get_proj(pid)
    puts "PID  Name"
    puts "  #{proj.id}   #{proj.name}"
  end

  def project_history(pid)
    pid = pid.to_i

    completed_tasks = TM.db.show_proj_tasks_complete(pid)
    puts "Priority    TID  Description"
    completed_tasks.each do |task|
        puts "       #{task.priority}      #{task.id}  #{task.description}"
    end
  end

  def project_recruit(pid, eid)
    pid = pid.to_i
    eid = eid.to_i

    emp = TM.db.add_emp_to_proj(pid, eid)
    puts "Adding employee #{emp.name} to project with PID #{pid}"
  end

  def project_employees(pid)
    pid = pid.to_i

    emps = TM.db.show_proj_participants(pid)
    puts "EID  Name"
    emps.each do |emp|
        puts "#{emp.id}  #{emp.name}"
    end
  end

  def task_create(pid, priority, *description_parts)
    pid = pid.to_i
    priority = priority.to_i
    description = description_parts.join(' ')
    TM.db.create_task(pid, priority, description)

    puts "Creating task with pid=#{pid}, priority=#{priority}, and description \"#{description}\""
  end

  def task_assign(tid, eid)
    tid = tid.to_i
    eid = eid.to_i

    task = TM.db.assign_task_to_emp(tid, eid)
    puts "Assigning task with tid=#{tid}, priority=#{task.priority}, and description \"#{task.description}\" to employee with eid=#{eid}"
  end

  def task_mark(tid)
    tid = tid.to_i

    task = TM.db.mark_task_as_complete(tid)
    puts "Marking task with tid=#{tid}, priority=#{task.priority}, and description \"#{task.description}\" as complete: #{task.completed}"
  end

  def emp_create(name)

    emp = TM.db.create_emp(name)
    puts "Creating an employee with eid=#{emp.id} and name \"#{emp.name}\""
  end

  def emp_list
    emps = TM.db.all_employees
    puts "EID  Name"
    emps.each do |emp|
      puts "#{emp.id}  #{emp.name}"
    end
  end

  def emp_show(eid)
    eid = eid.to_i

    emp = TM.db.get_emp(eid)
    puts "EID  Name"
    puts "#{emp.id}  #{emp.name}"
  end

  def emp_details(eid)
    eid = eid.to_i

    tasks_remaining = TM.db.show_emp_tasks_remaining(eid)
    puts "Priority    TID  Description  ProjectName"
    tasks_remaining.each do |task|
      puts "       #{task.priority}      #{task.id}  #{task.description}  #{TM.db.get_proj(task.proj_id).name}"
    end
  end

  def emp_history(eid)
    eid = eid.to_i

    tasks_complete = TM.db.show_emp_tasks_complete(eid)

    puts "Priority    TID  Description  ProjectName"
    tasks_complete.each do |task|
      puts "       #{task.priority}      #{task.id}  #{task.description}  #{TM.db.get_proj(task.proj_id).name}"
    end
  end

  def method_missing(meth, *args)
    puts "`#{meth.to_s.sub '_', ' '} #{args.join ' '}` is not a valid command"
  end
end

puts TERMINAL_PROMPT
TM::TerminalClient.new.start

