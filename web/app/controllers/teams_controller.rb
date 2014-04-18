class TeamsController < ApplicationController
  def index
    # binding.pry
    # @teams = Timeline.db.all_teams
    result = Timeline::GetTeams.run()
    
    @teams = result.teams
  end

  def show
    @team = Timeline.db.get_team(params[:team_id])
    @team_events = Timeline.db.get_events_by_team(params[:team_id])
  end
end
