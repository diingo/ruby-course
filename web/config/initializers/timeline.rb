require '../lib/timeline.rb'
Timeline.db_class = Timeline::Database::SQLiteDB
Timeline.env = 'development'
Timeline.db_seed
