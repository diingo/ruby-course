require 'spec_helper'

describe "AssignTaskToProj" do
  it "fails when the proj does not exist" do
    params = { :name => "do it" }
    result = TM::AssignTaskToProject.run(params)
    expect(result.error?).to eq(true)
    expect(result.error).to eq :missing_project
  end

  it "fails when user did not provide a task name" do
    project = TM.db.create_project('one')
    params = { :project_id => project.id }
    result = TM::AssignTaskToProject.run(params)
    expect(result.error?).to eq(true)
    expect(result.error).to eq(:missing_task_name)
  end

  it "adds a task to a project" do
    project = TM.db.create_project('one')
    params = { :project_id => project.id, :desc => "roll dice", :priority => 3 }
    result = TM::AssignTaskToProject.run(params)

    task = result.task
    retrieved_task = TM.db.get_task(task.id)
    expect(retrieved_task.proj_id).to eq(task.id)
  end
end