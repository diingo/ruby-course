require_relative '../spec_helper.rb'


describe "Add Task to Proj" do

  context "when pid is valid" do

    # need more narrowly defined test for this - test for exist, test for incomplete, etc
    xit "successfully validates a project exists and adds a task to it" do
      proj = TM.db.create_project("Save the World")

      result = TM::AddTaskToProj.run({ pid: proj.id, desc: "Plant a Tree", priority: 3 })
      expect(result.success?).to eq(true)
      expect(result.proj).to eq(proj)
      expect(result.task).to be_a(TM::Task)

      # binding.pry
      # task = TM.db.get_task(result.task.id)
      # expect(task.description).to eq("Plant a Tree")
      # expect(task.proj_id).to eq(proj.id)
    end
  end

  # context "when tid and eid are invalid" do
  #   it "fails" do
  #     emp = TM.db.create_emp("Jack")
  #     proj = TM.db.create_project("Save the World")
  #     task = TM.db.add_task_to_proj(proj.id, "plant some trees", 2)
  #     # ensure the ids don't exist
  #     eid = emp.id + 100
  #     tid = task.id + 100

  #     result = TM::AssignTaskToEmployee.run({ eid: eid, tid: tid })
  #     expect(result.success?).to eq(false)
  #     expect(result.error).to eq(:invalid_task)
  #   end
  # end
end