require 'spec_helper'

describe TM::AssignTaskToEmployee do
  before do
    @db = TM.db
  end

  it "adds a task to an employee" do
    # Set up our data
    proj = @db.create_proj("Eat Well")
    task = @db.create_task(proj.id, 'make me a sandwich', 2)
    emp = @db.create_emp('Bob')

    result = TM::AssignTaskToEmployee.run({ :tid => task.id, :eid => emp.id })
    expect(result.success?).to eq true
    expect(result.task.eid).to eq(emp.id)
  end

  it "errors if the task does not exist" do
    # Set up our data
    emp = @db.create_emp('Bob')

    result = subject.run({ :tid => 999, :eid => emp.id })
    expect(result.error?).to eq true
    expect(result.error).to eq :task_does_not_exist
  end

  it "errors if the employee does not exist" do
    proj = @db.create_proj("Eat Well")
    task = @db.create_task(proj.id, 'make me a sandwich', 2)

    result = subject.run({ :tid => task.id, :eid => 999 })
    expect(result.error?).to eq true
    expect(result.error).to eq :employee_does_not_exist
  end
end