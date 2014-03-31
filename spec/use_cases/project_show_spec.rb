require 'spec_helper'

describe TM::ProjectShow do
  before do
    @db = TM.db
  end

  it "shows a project" do
    proj = @db.create_proj('Become a Math Major')
    result = TM::ProjectShow.run({ :pid => proj.id })

    expect(result.success?).to eq(true)
    expect(result.project.id).to eq(proj.id)
  end

  it "errors if the proj does not exist" do
    result = TM::ProjectShow.run({ :pid => 999 })

    expect(result.error?).to eq(true)
    expect(result.error).to eq :project_does_not_exist
  end

end