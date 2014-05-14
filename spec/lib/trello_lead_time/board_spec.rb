require 'spec_helper'

describe TrelloLeadTime::Board do
  let(:key) { "key" }
  let(:token) { "token" }

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
    {
      "1111" => File.read(File.expand_path("../../../fixtures/actions.1111.json", __FILE__)),
      "2222" => File.read(File.expand_path("../../../fixtures/actions.2222.json", __FILE__)),
      "3333" => File.read(File.expand_path("../../../fixtures/actions.3333.json", __FILE__)),
      "4444" => File.read(File.expand_path("../../../fixtures/actions.4444.json", __FILE__))
    }
  }

  subject { TrelloLeadTime::Board.from_url(board_url) }

  describe ".totals" do
    let(:totals) { subject.totals(list_with_done_cards) }

    it "should have an overall lead time" do
      stub_all_requests
      totals[:lead_time][:overall].should == 4512370
    end

    it "should have an overall queue time" do
      stub_all_requests
      totals[:queue_time][:overall].should == 2697355
    end

    it "should have an overall cycle time" do
      stub_all_requests
      totals[:cycle_time][:overall].should == 1815015
    end

    it "should have an overall age" do
      stub_all_requests
      totals[:age][:overall].should == 4512370
    end
  end

  describe ".averages" do
    let(:averages) { subject.averages(list_with_done_cards) }

    it "should have an overall lead time" do
      stub_all_requests
      averages[:lead_time][:overall].should == 1128093
    end

    it "should have an overall queue time" do
      stub_all_requests
      averages[:queue_time][:overall].should == 674339
    end

    it "should have an overall cycle time" do
      stub_all_requests
      averages[:cycle_time][:overall].should == 453754
    end

    it "should have an overall age" do
      stub_all_requests
      averages[:age][:overall].should == 1128093
    end
  end

  private

  def stub_all_requests
    stub_board_requests
    stub_list_requests
    stub_card_requests
  end

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
