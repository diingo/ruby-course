require 'spec_helper'

describe 'DB' do
  before do
    @db = TM.db
  end

  describe '.initialize' do
    it "starts with no project, no employees, no tasks, no memberships" do
      expect(@db.all_projects).to eq([])
      expect(@db.all_tasks).to eq([])
      expect(@db.all_employees).to eq([])
      expect(@db.all_memberships).to eq([])
    end
  end

  #######################
  ## Task CRUD Methods ##
  #######################

  describe "Task CRUD Methods" do
    let(:proj) { @db.create_proj("The Best Proj") }


    it 'can create and get a task' do
      task = @db.create_task(proj.id, "Eat Tacos", 3)
      retrieved_task = @db.get_task(task.id)

      expect(task.description).to eq("Eat Tacos")
      expect(retrieved_task.description).to eq("Eat Tacos")
    end

    it 'can create and access all tasks' do
      task = @db.create_task(proj.id, "Eat Tacos", 3)
      all_task = @db.all_tasks
      expect(task.description).to eq("Eat Tacos")
      expect(@db.all_tasks.size).to eq(1)
    end

    it "can update a task" do

      added_task = @db.create_task(proj.id, "Eat Tacos", 3)

      @db.update_task(added_task.id, "Make Smores", 1)
      expect(added_task.description).to eq("Make Smores")
      expect(added_task.priority).to eq(1)
    end

    context "if update parameters are nil or empty" do
      it "will not change these parameters" do
        added_task = @db.create_task(proj.id, "Eat Tacos", 3)

        @db.update_task(added_task.id)
        expect(added_task.description).to eq("Eat Tacos")
        expect(added_task.priority).to eq(3)
      end
    end

    it "can delete a task" do
      task = @db.create_task(proj.id, "Eat Tacos", 3)
      expect(@db.tasks.length).to eq(1)

      @db.delete(task.id)
      expect(@db.get_task(task.id)).to be_nil
      expect(@db.all_tasks.length).to eq(0)
    end
  end

  ##########################
  ## Project CRUD Methods ##
  ##########################

  describe "other project CRUD methods" do

    let(:proj) { @db.create_proj("Travel The World") }

    it 'can create and get a proj' do
      proj = @db.create_proj("Collect Collectibles")

      retrieved_proj = @db.get_proj(proj.id)

      expect(proj.name).to eq("Collect Collectibles")
      expect(retrieved_proj.name).to eq("Collect Collectibles")
    end

    it 'can create and access all projects' do
      proj = @db.create_proj("Travel The World")
      all_proj = @db.all_projects
      expect(proj.name).to eq("Travel The World")
      expect(@db.all_projects.size).to eq(1)
    end

    it "can update a project" do
      retrieved_proj = @db.get_proj(proj.id)
      expect(proj.name).to eq("Travel The World")
      expect(retrieved_proj.name).to eq("Travel The World")

      @db.update_proj(proj.id, "Taking Over The World")

      expect(proj.name).to eq("Taking Over The World")
      expect(retrieved_proj.name).to eq("Taking Over The World")
    end

    context "if update parameters are nil or empty" do
      it "will not change these parameters" do
        @db.update_proj(proj.id)
        expect(proj.name).to eq("Travel The World")
      end
    end

    it "can delete a project" do
      # proj calls the let statement, otherwise it never gets executed so @db.projects is an empty hash
      proj

      expect(@db.all_projects.length).to eq(1)
      expect(@db.get_proj(proj.id)).to_not be_nil

      @db.delete_proj(proj.id)

      expect(@db.all_projects.length).to eq(0)
      expect(@db.get_proj(proj.id)).to be_nil
    end
  end

  ###########################
  ## Employee CRUD Methods ##
  ###########################


  describe "Employee CRUD Methods" do

    let(:emp) { @db.create_emp("Jack") }

    # tests both create and get method
    it 'can create and get an employee' do
      emp = @db.create_emp("Jack")

      expect(emp).to be_a(TM::Employee)
      expect(emp.name).to eq("Jack")
      expect(@db.get_emp(emp.id).name).to eq("Jack")
    end

    # tests create and all_employees method
    it 'can create and access all employees' do
      emp = @db.create_emp("Jack")

      expect(emp).to be_a(TM::Employee)
      expect(emp.name).to eq("Jack")
      expect(@db.all_employees.size).to eq(1)
    end

    it "can update an employee" do
      updated_emp = @db.update_emp(emp.id, "Bill")

      expect(updated_emp).to be_a(TM::Employee)
      expect(updated_emp.name).to eq("Bill")
      expect(emp.name).to eq("Bill")
    end

    it "can delete an employee" do
      expect(@db.employees[emp.id]).to_not be_nil
      expect(@db.employees.size).to eq(1)

      @db.delete_emp(emp.id)
      expect(@db.get_emp(emp.id)).to be_nil
      expect(@db.all_employees.size).to eq(0)
    end
  end

  ####################
  ## Client Queries ##
  ####################

  describe "Client Queries" do
    before do
      @emp = TM::Employee.new("Jinne")
      @proj = @db.create_proj("The Best Project")
    end
    it "can show remaining tasks for a project given PID" do

      @db.create_task(@proj.id, "Eat Tacos", 3)

      tasks_remaining = @db.show_proj_tasks_remaining(@proj.id)

      # This was a bad test because it did not fail when I refactored
      # expect(tasks_remaining).to eq(@proj.list_incomplete_tasks)

      expect(tasks_remaining).to be_a(Array)
      expect(tasks_remaining.size).to be(1)
      expect(tasks_remaining.first.description).to eq("Eat Tacos")
    end

    it "can show completed tasks for a project given PID" do
      @proj = @db.create_proj("The Best Project")
      added_task = @db.create_task(@proj.id, "Eat Tacos", 3)

      tasks_complete = @db.show_proj_tasks_complete(@proj.id)

      @db.mark_task_as_complete(added_task.id)
      tasks_complete = @db.show_proj_tasks_complete(@proj.id)

      expect(tasks_complete).to be_a(Array)
      expect(tasks_complete.size).to be(1)
      expect(tasks_complete.first.description).to eq("Eat Tacos")
    end

    context "an employee with multiple tasks" do
      before do
        @task_1 = @db.create_task(@proj.id, "Buy Something", 3)
        @task_2 = @db.create_task(@proj.id, "Eat Something", 2)
        @task_3 = @db.create_task(@proj.id, "Do Something", 4)

        @db.assign_task_to_emp(@task_1.id, @emp.id)
        @db.assign_task_to_emp(@task_2.id, @emp.id)
        @db.assign_task_to_emp(@task_3.id, @emp.id)
      end

      it "can show incomplete tasks assigned to an employee, given EID" do
        @db.mark_task_as_complete(@task_1.id)
        @db.mark_task_as_complete(@task_2.id)

        tasks = @db.show_emp_tasks_remaining(@emp.id)

        task_descriptions = tasks.map { |task| task.description }

        expect(task_descriptions).to include("Do Something")
        expect(task_descriptions).to_not include("Buy Something", "Eat Something")
      end

      it "can show completed tasks assigned to an employee, given EID" do
        @db.mark_task_as_complete(@task_1.id)
        @db.mark_task_as_complete(@task_2.id)

        tasks = @db.show_emp_tasks_complete(@emp.id)

        task_descriptions = tasks.map { |task| task.description }

        expect(task_descriptions).to include("Buy Something", "Eat Something")
        expect(task_descriptions).to_not include("Do Something")
      end
    end
  end

  #####################
  ## Client Commands ##
  #####################

  it "can mark a task as completed based on its id" do
    @proj_1 = @db.create_proj("The Best Project")
    added_task = @db.create_task(@proj_1.id, "Eat Tacos", 3)
    task_id = added_task.id

    completed_task = @db.mark_task_as_complete(task_id)

    expect(completed_task).to be_a(TM::Task)
    expect(completed_task.completed).to eq(true)
  end


  describe "associate employees and projects"do

    before do
      @emp = @db.create_emp("Jack")
      @proj = @db.create_proj("Collect Collectibles")
    end

    it "can allow an employee to participate in projects" do
      emp = @db.add_emp_to_proj(@proj.id, @emp.id)
      # binding.pry
      emp_projects = @db.show_emp_projs(emp.id)
      project_participants = @db.show_proj_participants(@proj.id)

      expect(@db.all_memberships.length).to eq(1)
      expect(emp_projects.first.name).to eq("Collect Collectibles")
      expect(project_participants.first.name).to eq("Jack")
    end
  end

  describe "associate employees and tasks" do
    before do
      @emp = @db.create_emp("Jack")
      @proj = @db.create_proj("Collect Collectibles")
      @task = @db.create_task(@proj.id, "Buy a Ruined Oldsmobile", 3)
    end

    it "can assign tasks to employees" do
      expect(@task.eid).to be_nil

      task = @db.assign_task_to_emp(@task.id, @emp.id)
      retrieved_task = @db.get_task(task.id)

      expect(@task.eid).to eq(@emp.id)
      expect(retrieved_task.eid).to eq(@emp.id)
    end
  end

end


# it "does stuff" do
#   task = db.create_task("do it")
#   task2 = db.get_task(task.id)

#   expect(task2.name).to eq("do it")
# end