require 'spec_helper'

describe TrelloLeadTime do
  describe ".configure" do
    it "yields TrelloLeadTime::Config" do
      expect { |b| TrelloLeadTime.configure(&b) }.to yield_with_args(TrelloLeadTime::Config)
    end
  end
end
