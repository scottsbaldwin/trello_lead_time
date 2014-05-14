require 'spec_helper'

describe TrelloLeadTime::Config do
  subject { TrelloLeadTime::Config }
  before(:all) do
    @cfg = {
      organization_name: TrelloLeadTime::Config.organization_name,
      queue_time_lists: TrelloLeadTime::Config.queue_time_lists,
      cycle_time_lists: TrelloLeadTime::Config.cycle_time_lists,
      list_name_matcher_for_done: TrelloLeadTime::Config.list_name_matcher_for_done
    }
  end

  after(:all) do
    TrelloLeadTime.configure do |cfg|
      cfg.queue_time_lists           = @cfg[:queue_time_lists]
      cfg.cycle_time_lists           = @cfg[:cycle_time_lists]
      cfg.organization_name          = @cfg[:organization_name]
      cfg.list_name_matcher_for_done = @cfg[:list_name_matcher_for_done]
    end
  end

  it "should have default empty list for queue time lists" do
    TrelloLeadTime.configure do |cfg|
      cfg.queue_time_lists = nil
    end
    subject.queue_time_lists.should be_empty
  end

  it "should set queue time lists" do
    TrelloLeadTime.configure do |cfg|
      cfg.queue_time_lists = ["my list"]
    end
    subject.queue_time_lists.should include("my list")
  end

  it "should have default empty list for cycle time lists" do
    TrelloLeadTime.configure do |cfg|
      cfg.cycle_time_lists = nil
    end
    subject.cycle_time_lists.should be_empty
  end

  it "should set cycle time lists" do
    TrelloLeadTime.configure do |cfg|
      cfg.cycle_time_lists = ["my list"]
    end
    subject.cycle_time_lists.should include("my list")
  end

  it "should have default done matcher" do
    TrelloLeadTime.configure do |cfg|
      cfg.list_name_matcher_for_done = nil
    end
    expect(subject.list_name_matcher_for_done).to eq(/^Done/i)
  end

  it "should set a default done matcher" do
    TrelloLeadTime.configure do |cfg|
      cfg.list_name_matcher_for_done = /^Live/ end
    expect(subject.list_name_matcher_for_done).to eq(/^Live/)
  end
end
