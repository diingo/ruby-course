require 'active_model'
require 'active_record'
require 'active_record_tasks'
require 'pry-debugger'
require 'yaml'

module Timeline
  def self.db
    @__db_instance ||= Database::InMemory.new
  end
end

require_relative 'timeline/entity.rb'
require_relative 'use_case.rb'

Gem.find_files("timeline/database/*.rb").each { |path| require path }
Gem.find_files("timeline/entities/*.rb").each { |path| require path }
Gem.find_files("timeline/use_cases/*.rb").each { |path| require path }


