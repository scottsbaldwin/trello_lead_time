require 'spec_helper'

describe TrelloLeadTime::ArraySearcher do
  describe "array searcher" do
    let(:elements) { ["Development [4]", "Acceptance [3]", "Done for 2014-05-05"] }
    subject { Object.new.extend TrelloLeadTime::ArraySearcher }

    it "should find a name" do
      expect(subject.find_name_like(elements, "Development")).to eq("Development [4]")
    end

    it "matches name with expression" do
      expect(subject.element_matches_expression?("Development [4]", "Development")).to_not be_nil
    end
  end
end
