require 'spec_helper'

describe Timeline::GetTeams do
  let(:result) { subject.run() }
  let(:team1) { Timeline.db.create_team :name => 'Operations' }
  let(:team2) { Timeline.db.create_team :name => 'Students' }
  let(:team3) { Timeline.db.create_team :name => 'People' }

  before do
    Timeline.db.clear_everything
  end
  
  it 'retrieves all teams from the db' do
    # typing the team1, team2, team3 variables runs the let statements
    # we need to do this because we're not using team1, etc anywhere else in this it block so the let statements won't get executed otherwise
    team1
    team2
    team3
    expect(result.success?).to eq(true)
    expect(result.teams.map(&:name)).to include('Operations', 'Students', 'People')
    expect(result.teams.length).to eq(3)
  end

end