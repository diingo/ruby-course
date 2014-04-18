class TeamsController < ApplicationController
  def index
    # binding.pry
    # @teams = Timeline.db.all_teams
    result = Timeline::GetTeams.run()

    @teams = result.teams
  end

  def show
    # binding.pry
    result = Timeline::GetTeamEvents.run(team_id: params[:team_id])
    @team = result.team
    @team_events = result.events
  end
end
