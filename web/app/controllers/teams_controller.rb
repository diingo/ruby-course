class TeamsController < ApplicationController
  def index
    # binding.pry
    # @teams = Timeline.db.all_teams
    result = Timeline::GetTeams.run({})

    @teams = result.teams
  end

  def show
    # binding.pry
    result = Timeline::GetTeamEvents.run(team_id: params[:team_id])

    @event = Timeline::Event.new
    # @team = result.team


    if result.success?
      # binding.pry
      @message = 'it worked'
      @team = result.team
      @team_events = result.events
      @team_id = params[:team_id]
    else
      flash[:notice] = result.error
      redirect_to '/teams/index'
    end
  end
end
