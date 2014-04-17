module Timeline
  class GetTeamEvents < UseCase
    def run(inputs)
      team = Timeline.db.get_team(inputs[:team_id])
      return failure(:missing_team) if team.nil?

      events = Timeline.db.get_events_by_team(inputs[:team_id])
      success(team: team, events: events)
    end
  end
end