require 'spec_helper'

describe Timeline::CreateEvent do
  let(:result) { subject.run(@params) }
  let(:user) { Timeline.db.create_user :name => 'Bob' }
  let(:team) { Timeline.db.create_team :name => 'Operations' }
  let(:lorem_text) { "lorem ipsum" }

  before do
    Timeline.db.clear_everything
    @params = {
      :user_id => user.id,
      :team_id => team.id,
      :name => "Met Bob" ,
      :content => lorem_text,
      :tags => []
    }
  end

  describe "Error handling" do
    it "ensures user exists" do
      @params[:user_id] = 9999
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:missing_user)
    end

    it "ensures team exists" do
      @params[:team_id] = 9999
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:missing_team)
    end

    it "ensures event has a valid name" do
      @params[:name] = ''
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:invalid_event)
    end
  end

  it "creates an event attached to a team" do
    expect(result.success?).to eq(true)

    expect(result.user.id).to eq(user.id)
    expect(result.team.id).to eq(team.id)
    expect(result.event.name).to eq 'Met Bob'
    expect(result.event.content).to eq(lorem_text)
  end

  it "saves the event to the database" do
    @params[:name] = "I persisted"
    expect(result.success?).to eq(true)

    event = Timeline.db.get_event(result.event.id)
    expect(event.name).to eq "I persisted"
    expect(event.content).to eq(lorem_text)
  end

  it "converts all ids to integers" do
    @params[:user_id] = user.id.to_s
    @params[:team_id] = team.id.to_s
    # binding.pry
    expect(result.success?).to eq(true)
    expect(result.user.id).to eq(user.id)
    expect(result.team.id).to eq(team.id)
  end

  it "defaults tags to an empty array" do
    @params[:tags] = nil
    expect(result.success?).to eq(true)
  end
  
  xit "downcases all tags" do
    @params[:tags] = ['classroom', 'JavaScript']
    expect(result.success?).to eq(true)

    event = result.event
    expect(event.tags.count).to eq 2
    expect(event.tags).to include('classroom', 'javascript')
  end

  xit "strips spaces" do
    @params[:tags] = [' one', 'two ', ' three ', ' four and five']
    expect(result.success?).to eq(true)

    event = result.event
    expect(event.tags.count).to eq 4
    expect(event.tags).to include('one', 'two', 'three', 'four and five')
  end
end