require_relative '../spec_helper.rb'

describe "Assign Task to Employee" do

  # no longer need this since
  # code in spec_helper will create fresh instance for each test
  # before do
  #   @db = TM::DB.new
  # end

  context "when tid and eid are valid" do

    # need more narrowly defined test for this - test for exist, test for incomplete, etc
    it "successfully validates a task exists and has not already been completed" do
      # binding.pry
      emp = TM.db.create_emp("Jack")
      proj = TM.db.create_project("Save the World")
      task = TM.db.add_task_to_proj(proj.id, "plant some trees", 2)

      result = TM::AssignTaskToEmployee.run({ eid: emp.id, tid: task.id })
      expect(result.success?).to eq(true)
      expect(result.task).to eq(task)
      expect(result.get_employee).to eq(emp)

      updated_task = TM.db.get_task(task.id)
      expect(updated_task.id).to eq(task.id)
      expect(updated_task.eid).to eq(emp.id)
    end
  end

  context "when tid and eid are invalid" do
    xit "fails" do
      emp = TM.db.create_emp("Jack")
      proj = TM.db.create_project("Save the World")
      task = TM.db.add_task_to_proj(proj.id, "plant some trees", 2)
      # ensure the ids don't exist
      eid = emp.id + 100
      tid = task.id + 100

      result = TM::AssignTaskToEmployee.run({ eid: eid, tid: tid })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:invalid_task)
    end
  end
end