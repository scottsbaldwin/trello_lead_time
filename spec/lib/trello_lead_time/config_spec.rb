require 'trello_lead_time'

describe TrelloLeadTime::Config do
  describe ".public_key" do
    subject { TrelloLeadTime::Config.public_key }

    before do
      TrelloLeadTime::Config.public_key = 'abc'
    end

    it 'sets the public key' do
      subject.should == 'abc'
    end
  end

  describe ".member_token" do
    subject { TrelloLeadTime::Config.member_token }

    before do
      TrelloLeadTime::Config.member_token = 'abc'
    end

    it 'sets the member token' do
      subject.should == 'abc'
    end
  end
end
