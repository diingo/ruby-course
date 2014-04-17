require 'spec_helper'

describe Timeline::GetTeamEvents do
  let(:result) { subject.run(@params) }
  let(:team) { Timeline.db.create_team :name => 'Operations' }

  before do
    @params = {
      :team_id => team.id
    }
    Timeline.db.create_event(team_id: team.id, name: "x")
    Timeline.db.create_event(team_id: team.id, name: "y")
    Timeline.db.create_event(team_id: team.id, name: "z")
  end

  describe "Error handling" do
    it "ensures team exists" do
      @params[:team_id] = 9999
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:missing_team)
    end
  end

  it "retrieves the events for a team" do
    expect(result.success?).to eq(true)

    expect(result.events.map(&:name)).to include("x", "y", "z")
  end

end