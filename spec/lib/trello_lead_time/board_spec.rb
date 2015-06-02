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
  let(:list_not_found_on_board) { "Not a real list" }
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

  let(:missing_lists_json) {
    File.read(File.expand_path("../../../fixtures/missing_lists.json", __FILE__))
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

  let(:labels_json) {
    {
      "1111" => File.read(File.expand_path("../../../fixtures/labels.1111.json", __FILE__)),
      "2222" => File.read(File.expand_path("../../../fixtures/labels.2222.json", __FILE__)),
      "3333" => File.read(File.expand_path("../../../fixtures/labels.3333.json", __FILE__)),
      "4444" => File.read(File.expand_path("../../../fixtures/labels.4444.json", __FILE__))
    }
  }

  let(:comments_json) {
    {
      "1111" => File.read(File.expand_path("../../../fixtures/comments.1111.json", __FILE__)),
      "2222" => File.read(File.expand_path("../../../fixtures/comments.2222.json", __FILE__)),
      "3333" => File.read(File.expand_path("../../../fixtures/comments.3333.json", __FILE__)),
      "4444" => File.read(File.expand_path("../../../fixtures/comments.4444.json", __FILE__))
    }
  }

  subject { TrelloLeadTime::Board.from_url(board_url) }

  describe '#cards' do
    it "should have some cards" do
      stub_all_requests
      expect(subject.cards(list_with_done_cards).length).to eq(4)
    end

    it "should default an empty list of cards when list is not found" do
      stub_all_requests_missing_list
      expect(subject.cards(list_not_found_on_board).length).to eq(0)
    end
  end

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

    it "should have a lead time breakdown by finance type" do
      stub_all_requests
      totals[:lead_time][:finance_types].should == {"CapEx" => 1664755, "OpEx" => 474615}
    end

    it "should have a queue time breakdown by finance type" do
      stub_all_requests
      totals[:queue_time][:finance_types].should == {"CapEx" => 864055, "OpEx" => 177300}
    end

    it "should have a cycle time breakdown by finance type" do
      stub_all_requests
      totals[:cycle_time][:finance_types].should == {"CapEx" => 800700, "OpEx" => 297315}
    end

    it "should have an age breakdown by finance type" do
      stub_all_requests
      totals[:age][:finance_types].should == {"CapEx" => 1664755, "OpEx" => 474615}
    end

    it "should have a lead time breakdown by initiative" do
      stub_all_requests
      totals[:lead_time][:initiatives].should == {"#tag1" => 428155, "#tag2" => 1711215, "#tag3" => 2373000}
    end

    it "should have a queue time breakdown by initiative" do
      stub_all_requests
      totals[:queue_time][:initiatives].should == {"#tag1" => 327355, "#tag2" => 714000, "#tag3" => 1656000}
    end

    it "should have a cycle time breakdown by initiative" do
      stub_all_requests
      totals[:cycle_time][:initiatives].should == {"#tag1" => 100800, "#tag2" => 997215, "#tag3" => 717000}
    end

    it "should have an age breakdown by initiative" do
      stub_all_requests
      totals[:age][:initiatives].should == {"#tag1" => 428155, "#tag2" => 1711215, "#tag3" => 2373000}
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

    it "should have a lead time breakdown by finance type" do
      stub_all_requests
      averages[:lead_time][:finance_types].should == {"CapEx" => 832378, "OpEx" => 474615}
    end

    it "should have a queue time breakdown by finance type" do
      stub_all_requests
      averages[:queue_time][:finance_types].should == {"CapEx" => 432028, "OpEx" => 177300}
    end

    it "should have a cycle time breakdown by finance type" do
      stub_all_requests
      averages[:cycle_time][:finance_types].should == {"CapEx" => 400350, "OpEx" => 297315}
    end

    it "should have an age breakdown by finance type" do
      stub_all_requests
      averages[:age][:finance_types].should == {"CapEx" => 832378, "OpEx" => 474615}
    end

    it "should have an average lead time breakdown by initiative" do
      stub_all_requests
      averages[:lead_time][:initiatives].should == {"#tag1" => 428155, "#tag2" => 855608, "#tag3" => 2373000}
    end

    it "should have an average queue time breakdown by initiative" do
      stub_all_requests
      averages[:queue_time][:initiatives].should == {"#tag1" => 327355, "#tag2" => 357000, "#tag3" => 1656000}
    end

    it "should have an average cycle time breakdown by initiative" do
      stub_all_requests
      averages[:cycle_time][:initiatives].should == {"#tag1" => 100800, "#tag2" => 498608, "#tag3" => 717000}
    end

    it "should have an average age breakdown by initiative" do
      stub_all_requests
      averages[:age][:initiatives].should == {"#tag1" => 428155, "#tag2" => 855608, "#tag3" => 2373000}
    end
  end

  private

  def stub_all_requests
    stub_board_requests
    stub_list_requests
    stub_card_requests
  end

  def stub_all_requests_missing_list
    stub_board_requests
    stub_missing_list_requests
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

  def stub_missing_list_requests
    stub_request(:get, "https://api.trello.com/1/boards/#{board_id}/lists?filter=all&key=#{key}&token=#{token}").
      with(headers).
      to_return(stub_returns(missing_lists_json))
  end

  def stub_card_requests
    %w{1111 2222 3333 4444}.each do |card_id|
      stub_request(:get, "https://api.trello.com/1/cards/#{card_id}/actions?filter=copyCard,moveCardToBoard,createCard,updateCard:idList,updateCard:closed&key=#{key}&token=#{token}").
        with(headers).
        to_return(stub_returns(actions_json[card_id]))

      stub_request(:get, "https://api.trello.com/1/cards/#{card_id}/labels?key=#{key}&token=#{token}").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => labels_json[card_id], :headers => {})

      stub_request(:get, "https://api.trello.com/1/cards/#{card_id}/actions?filter=commentCard&key=#{key}&token=#{token}").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => comments_json[card_id], :headers => {})
    end
  end

  def headers
    { headers: {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'} }
  end

  def stub_returns(json)
    { status: 200, body: json, headers: {} }
  end
end
