module Timeline
  class CreateEvent < UseCase
    def run(inputs)
      # binding.pry
      user = Timeline.db.get_user(inputs[:user_id])
      return failure(:missing_user) if user.nil?

      team = Timeline.db.get_team(inputs[:team_id])
      return failure(:missing_team) if team.nil?

      return failure(:invalid_event) if inputs[:name].empty?

      inputs[:tags].map! { |tag| tag.downcase.strip }

      event = Timeline.db.create_event(inputs)

      success( user: user, team: team, event: event )
    end
  end
end