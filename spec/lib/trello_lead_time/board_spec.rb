require 'spec_helper'

describe TrelloLeadTime::Board do
  let(:key) { "key" }
  let(:token) { "token" }

  describe ".from_url" do
    let(:organization_id) { "myorg_id" }
    let(:organization_name) { "myorg_name" }
    let(:url) { "https://trello.com/#{organization_name}" }
    let(:board_url) { "http://trello.com/b/1234/board_name" }
    let(:board_id) { "myboard_id" }
    let(:board_name) { "Development Team" }
    let(:list_with_done_cards) { "Done for 2014-03" }
    let(:list_id) { "mylist_id" }
    let(:card_id) { "mycard_id" }

    let(:organization_json) {
      File.read(File.expand_path("../../../fixtures/organization.json", __FILE__))
    }

    let(:boards_json) {
      File.read(File.expand_path("../../../fixtures/boards.json", __FILE__))
    }

    let(:lists_json) {
      File.read(File.expand_path("../../../fixtures/lists.json", __FILE__))
    }

    let(:cards_json) {
      File.read(File.expand_path("../../../fixtures/cards.json", __FILE__))
    }

    let(:actions_json) {
      File.read(File.expand_path("../../../fixtures/actions.json", __FILE__))
    }

    subject { TrelloLeadTime::Board.from_url(board_url) }

    it "should return a board" do
      stub_board_requests
      subject.should be_an_instance_of(TrelloLeadTime::Board)
    end

    it "should have a lead time" do
      stub_board_requests
      stub_list_requests
      stub_card_requests
      lead_time = subject.average_lead_time(list_with_done_cards)
      # 4d 22h 55m 55s
      lead_time.should == 428155
    end
  end

  private

  def stub_board_requests
    stub_request(:get, "https://api.trello.com/1/organizations/wellmatch?key=#{key}&token=#{token}").
      with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => organization_json, :headers => {})
    stub_request(:get, "https://api.trello.com/1/organizations/#{organization_id}/boards/all?key=#{key}&token=#{token}").
      with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => boards_json, :headers => {})
  end

  def stub_list_requests
    stub_request(:get, "https://api.trello.com/1/boards/#{board_id}/lists?filter=all&key=#{key}&token=#{token}").
      with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => lists_json, :headers => {})
    stub_request(:get, "https://api.trello.com/1/lists/#{list_id}/cards?filter=open&key=#{key}&token=#{token}").
      with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => cards_json, :headers => {})
  end

  def stub_card_requests
    stub_request(:get, "https://api.trello.com/1/cards/#{card_id}/actions?filter=createCard,updateCard:idList,updateCard:closed&key=#{key}&token=#{token}").
      with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => actions_json, :headers => {})
  end
end
