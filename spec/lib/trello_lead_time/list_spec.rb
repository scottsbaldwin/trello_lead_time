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

  let(:labels) {
    %w{CapEx OpEx}
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

  it "should have total lead times by label" do
    stub_all_requests
    times = subject.breakdown_by_labels(labels)
    expect(times[:total][:lead_time]).to eq({"CapEx" => 1664755, "OpEx" => 474615})
  end

  it "should have total queue times by label" do
    stub_all_requests
    times = subject.breakdown_by_labels(labels)
    expect(times[:total][:queue_time]).to eq({"CapEx" => 864055, "OpEx" => 177300})
  end

  it "should have total cycle times by label" do
    stub_all_requests
    times = subject.breakdown_by_labels(labels)
    expect(times[:total][:cycle_time]).to eq({"CapEx" => 800700, "OpEx" => 297315})
  end

  it "should have total ages by label" do
    stub_all_requests
    times = subject.breakdown_by_labels(labels)
    expect(times[:total][:age]).to eq({"CapEx" => 1664755, "OpEx" => 474615})
  end

  it "should have average lead times by label" do
    stub_all_requests
    times = subject.breakdown_by_labels(labels)
    expect(times[:average][:lead_time]).to eq({"CapEx" => 832378, "OpEx" => 474615})
  end

  it "should have average queue times by label" do
    stub_all_requests
    times = subject.breakdown_by_labels(labels)
    expect(times[:average][:queue_time]).to eq({"CapEx" => 432028, "OpEx" => 177300})
  end

  it "should have average cycle times by label" do
    stub_all_requests
    times = subject.breakdown_by_labels(labels)
    expect(times[:average][:cycle_time]).to eq({"CapEx" => 400350, "OpEx" => 297315})
  end

  it "should have average ages by label" do
    stub_all_requests
    times = subject.breakdown_by_labels(labels)
    expect(times[:average][:age]).to eq({"CapEx" => 832378, "OpEx" => 474615})
  end

  it "should have total lead times by tag" do
    stub_all_requests
    times = subject.breakdown_by_tags
    expect(times[:total][:lead_time]).to eq({"#tag1" => 428155, "#tag2" => 1711215, "#tag3" => 2373000})
  end

  it "should have total queue times by tag" do
    stub_all_requests
    times = subject.breakdown_by_tags
    expect(times[:total][:queue_time]).to eq({"#tag1" => 327355, "#tag2" => 714000, "#tag3" => 1656000})
  end

  it "should have total cycle times by tag" do
    stub_all_requests
    times = subject.breakdown_by_tags
    expect(times[:total][:cycle_time]).to eq({"#tag1" => 100800, "#tag2" => 997215, "#tag3" => 717000})
  end

  it "should have total ages by tag" do
    stub_all_requests
    times = subject.breakdown_by_tags
    expect(times[:total][:age]).to eq({"#tag1" => 428155, "#tag2" => 1711215, "#tag3" => 2373000})
  end

  it "should have average lead times by tag" do
    stub_all_requests
    times = subject.breakdown_by_tags
    expect(times[:average][:lead_time]).to eq({"#tag1" => 428155, "#tag2" => 855608, "#tag3" => 2373000})
  end

  it "should have average queue times by tag" do
    stub_all_requests
    times = subject.breakdown_by_tags
    expect(times[:average][:queue_time]).to eq({"#tag1" => 327355, "#tag2" => 357000, "#tag3" => 1656000})
  end

  it "should have average cycle times by tag" do
    stub_all_requests
    times = subject.breakdown_by_tags
    expect(times[:average][:cycle_time]).to eq({"#tag1" => 100800, "#tag2" => 498608, "#tag3" => 717000})
  end

  it "should have average ages by tag" do
    stub_all_requests
    times = subject.breakdown_by_tags
    expect(times[:average][:age]).to eq({"#tag1" => 428155, "#tag2" => 855608, "#tag3" => 2373000})
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
