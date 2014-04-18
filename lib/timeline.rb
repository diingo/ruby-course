require 'active_model'
require 'active_record'
require 'active_record_tasks'
require 'pry-debugger'
require 'yaml'

module Timeline
  def self.db
    @db_class ||= Database::InMemory
    @__db_instance ||= @db_class.new
  end

  def self.db_class=(db_class)
    @db_class = db_class
  end

  def self.db_seed
    team_1 = self.db.create_team(name: "The Happy Makers")
    team_2 = self.db.create_team(name: "The People")
    team_3 = self.db.create_team(name: "The Funnies")
    user = self.db.create_user(name: "Mario")
    event = self.db.create_event(name: user.name, user_id: user.id, team_id: team_1.id )
  end
end

require_relative 'timeline/entity.rb'
require_relative 'use_case.rb'

# Gem.find_files("timeline/database/*.rb").each { |path| require path }
# Gem.find_files("timeline/entities/*.rb").each { |path| require path }
# Gem.find_files("timeline/use_cases/*.rb").each { |path| require path }
Dir["#{File.dirname(__FILE__)}/timeline/database/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/timeline/entities/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/timeline/use_cases/*.rb"].each { |f| require(f) }


