require 'spec_helper'

describe TrelloLeadTime::List do
  let(:key) { "key" }
  let(:token) { "token" }

  let(:list) {
    l = Trello::List.new
    l.attributes[:id]       = 12345
    l.attributes[:name]     = 'Test List'
    l.attributes[:closed]   = false
    l.attributes[:board_id] = 67890
    l.attributes[:pos]      = 1
    l
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

  subject { TrelloLeadTime::List.from_trello_list(list) }

  it "should have an average age" do
    stub_all_requests
    subject.average_age.should == 1128093
  end

  it "should have a total age" do
    stub_all_requests
    subject.total_age.should == 4512370
  end

  it "should have a average lead time" do
    stub_all_requests
    subject.average_lead_time.should == 1128093
  end

  it "should have a total lead time" do
    stub_all_requests
    subject.total_lead_time.should == 4512370
  end

  it "should have a average queue time" do
    stub_all_requests
    subject.average_queue_time.should == 674339
  end

  it "should have a total queue time" do
    stub_all_requests
    subject.total_queue_time.should == 2697355
  end

  it "should have a average cycle time" do
    stub_all_requests
    subject.average_cycle_time.should == 453754
  end

  it "should have a total cycle time" do
    stub_all_requests
    subject.total_cycle_time.should == 1815015
  end

  private

  def stub_all_requests
    stub_list_requests
    stub_card_requests
  end

  def stub_list_requests
    stub_request(:get, "https://api.trello.com/1/lists/#{list.id}/cards?filter=open&key=#{key}&token=#{token}").
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
