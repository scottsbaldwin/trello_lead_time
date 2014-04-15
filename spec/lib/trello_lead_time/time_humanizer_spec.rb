require 'spec_helper'

describe TrelloLeadTime::TimeHumanizer do
  describe ".humanize_seconds" do
    let(:seconds) { 428155 }
    subject { TrelloLeadTime::TimeHumanizer.humanize_seconds(seconds) }

    it "should have days, hours, mins, and seconds" do
      subject.should == "4 days 22 hours 55 minutes 55 seconds"
    end
  end
end
