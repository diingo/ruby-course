
class TM::Task
  attr_reader :proj_id
  attr_reader :id
  attr_accessor :description, :priority
  attr_reader :time_created
  attr_accessor :time_completed, :eid
  # have custom setter for :completed
  attr_reader :completed

  @@counter = 0

  def self.gen_id
    @@counter += 1
    @@counter
  end

  def initialize(proj_id, desc, priority)
    @proj_id = proj_id
    @description = desc
    @priority = priority
    @id = TM::Task.gen_id

    # task defaults as incomplete
    @completed = false

    @time_created = Time.now

    # task has no completed time when first created
    @time_completed = nil

    @eid = nil
  end

  def completed=(new_value)
    if new_value == true
      @completed = true
      @time_completed = Time.now
    else
      @completed = false
    end
  end

end
