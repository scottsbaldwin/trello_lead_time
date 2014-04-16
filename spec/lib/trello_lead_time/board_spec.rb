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
    let(:queue_lists) { [ "Product Backlog" ] }
    let(:cycle_time_lists) { [ "Development", "Acceptance" ] }

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
      {
        "1111" => File.read(File.expand_path("../../../fixtures/actions.1111.json", __FILE__)),
        "2222" => File.read(File.expand_path("../../../fixtures/actions.2222.json", __FILE__)),
        "3333" => File.read(File.expand_path("../../../fixtures/actions.3333.json", __FILE__)),
        "4444" => File.read(File.expand_path("../../../fixtures/actions.4444.json", __FILE__))
      }
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
      # 13 days 1 hours 21 minutes 33 seconds
      lead_time.should == 1128093
    end

    it "should have a queue time" do
      stub_board_requests
      stub_list_requests
      stub_card_requests
      queue_time = subject.average_queue_time(list_with_done_cards, queue_lists)
      # 7 days 19 hours 18 minutes 59 seconds
      queue_time.should == 674339
    end

    it "should have a cycle time" do
      stub_board_requests
      stub_list_requests
      stub_card_requests
      cycle_time = subject.average_cycle_time(list_with_done_cards, cycle_time_lists)
      # 5 days 6 hours 2 minutes 34 seconds
      cycle_time.should == 453754
    end
  end

  private

  def stub_board_requests
    stub_request(:get, "https://api.trello.com/1/organizations/wellmatch?key=#{key}&token=#{token}").
      with(headers).
      to_return(stub_returns(organization_json))

    stub_request(:get, "https://api.trello.com/1/organizations/#{organization_id}/boards/all?key=#{key}&token=#{token}").
      with(headers).
      to_return(stub_returns(boards_json))
  end

  def stub_list_requests
    stub_request(:get, "https://api.trello.com/1/boards/#{board_id}/lists?filter=all&key=#{key}&token=#{token}").
      with(headers).
      to_return(stub_returns(lists_json))

    stub_request(:get, "https://api.trello.com/1/lists/#{list_id}/cards?filter=open&key=#{key}&token=#{token}").
      with(headers).
      to_return(stub_returns(cards_json))
  end

  def stub_card_requests
    %w{1111 2222 3333 4444}.each do |card_id|
      stub_request(:get, "https://api.trello.com/1/cards/#{card_id}/actions?filter=createCard,updateCard:idList,updateCard:closed&key=#{key}&token=#{token}").
        with(headers).
        to_return(stub_returns(actions_json[card_id]))
    end
  end

  def headers
    { headers: {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'} }
  end

  def stub_returns(json)
    { status: 200, body: json, headers: {} }
  end
end
