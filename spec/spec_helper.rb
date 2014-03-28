# Require our project, which in turns requires everything else
require './lib/task-manager.rb'
require 'pry-debugger'
require 'time'

# # this configures rspec so that each test gets a newly created singleton instance
# RSpec.configure do |config|
#   # Reset singleton instance before every test
#   config.before(:each) do
#     Singleton.__init__(TM::DB)
#   end
# end


# This goes in spec_helper.rb
RSpec.configure do |config|
  # Configure each test to always use a new singleton instance
  config.before(:each) do
    TM.instance_variable_set(:@__db_instance, nil)
  end
end
