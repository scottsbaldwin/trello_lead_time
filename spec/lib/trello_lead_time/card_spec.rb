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
  let(:labels_json) {
    File.read(File.expand_path("../../../fixtures/labels.json", __FILE__))
  }
  let(:comments_json) {
    File.read(File.expand_path("../../../fixtures/comments.json", __FILE__))
  }

  subject { TrelloLeadTime::Card.from_trello_card(Trello::Card.parse(card_json)) }

  def do_stubs(key, token)
    stub_request(:get, "https://api.trello.com/1/cards/533dd01513e035206902124c/actions?filter=createCard,updateCard:idList,updateCard:closed&key=#{key}&token=#{token}").
      with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => actions_json, :headers => {})

    stub_request(:get, "https://api.trello.com/1/cards/533dd01513e035206902124c/labels?key=#{key}&token=#{token}").
      with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => labels_json, :headers => {})

    stub_request(:get, "https://api.trello.com/1/cards/533dd01513e035206902124c/actions?filter=commentCard&key=#{key}&token=#{token}").
      with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => comments_json, :headers => {})
  end

  describe ".done" do
    it "should be a card" do
      do_stubs(key, token)
      subject.should be_an_instance_of(TrelloLeadTime::Card)
    end
  end

  describe ".hash_tags" do
    it "should have a hash tag" do
      do_stubs(key, token)
      expect(subject.hash_tags).to eq(%w{#tag1 #tag2 #tag3})
    end
  end

  describe ".labels" do
    it "should have labels" do
      do_stubs(key, token)
      expect(subject.labels.collect(&:name)).to eq(%w{iOS API})

    end
  end

  describe ".has_label_name?" do
    it "should not have a named label" do
      do_stubs(key, token)
      subject.has_label_name?("blah").should be_false
    end

    it "should have a named label" do
      do_stubs(key, token)
      subject.has_label_name?("ios").should be_true
    end
  end

  describe ".has_label_color?" do
    it "should not have a color label" do
      do_stubs(key, token)
      subject.has_label_color?("yellow").should be_false
    end

    it "should have a color label" do
      do_stubs(key, token)
      subject.has_label_color?("Green").should be_true
    end
  end
end
