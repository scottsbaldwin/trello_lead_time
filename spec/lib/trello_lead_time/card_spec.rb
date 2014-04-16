require 'spec_helper'

describe TrelloLeadTime::Card do
  let(:key) { 'key' }
  let(:token) { 'token' }
  let(:card_json) {
    File.read(File.expand_path("../../../fixtures/card.json", __FILE__))
  }
  let(:actions_json) {
    File.read(File.expand_path("../../../fixtures/actions.1111.json", __FILE__))
  }

  describe ".done" do
    subject { TrelloLeadTime::Card.from_trello_card(Trello::Card.parse(card_json)) }

    it "should be a card" do
      stub_request(:get, "https://api.trello.com/1/cards/533dd01513e035206902124c/actions?filter=createCard,updateCard:idList,updateCard:closed&key=#{key}&token=#{token}").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => actions_json, :headers => {})

      subject.should be_an_instance_of(TrelloLeadTime::Card)
    end
  end
end
