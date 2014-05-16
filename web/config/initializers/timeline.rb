require '../lib/timeline.rb'
Timeline.db_class = Timeline::Database::PostGres
Timeline.env = 'development'
Timeline.db_seed
