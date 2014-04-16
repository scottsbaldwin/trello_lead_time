require 'spec_helper'

describe TrelloLeadTime::Config do
  describe ".add_queue_time_list" do
    subject { TrelloLeadTime::Config }

    it "should have default empty list for queue time lists" do
      subject.queue_time_lists.should be_empty
    end

    it "should set queue time lists" do
      TrelloLeadTime.configure do |cfg|
        cfg.queue_time_lists = ["my list"]
      end
      subject.queue_time_lists.should include("my list")
    end

    it "should have default empty list for cycle time lists" do
      subject.cycle_time_lists.should be_empty
    end

    it "should set cycle time lists" do
      TrelloLeadTime.configure do |cfg|
        cfg.cycle_time_lists = ["my list"]
      end
      subject.cycle_time_lists.should include("my list")
    end
  end
end
