require 'spec_helper'

describe TrelloLeadTime::Board do
  describe ".for" do
    let(:board_id) { "BOARD" }
    let(:key) { "key" }
    let(:token) { "token" }
    let(:board_name) { "Transparency Backend" }

    let(:board_json) {
      <<-END_OF_JSON
      {
        "closed": false,
        "desc": "",
        "descData": {
          "emoji": {}
        },
        "id": "#{board_id}",
        "idOrganization": "52055e8d7110d36b210028db",
        "labelNames": {
          "blue": "Adopted",
          "green": "",
          "orange": "Unplanned",
          "purple": "Needs grooming by team",
          "red": "Blocked",
          "yellow": "Lacking definition for grooming"
        },
        "name": "#{board_name}",
        "pinned": true,
        "prefs": {
          "background": "blue",
          "backgroundBrightness": "unknown",
          "backgroundColor": "#23719F",
          "backgroundImage": null,
          "backgroundImageScaled": null,
          "backgroundTile": false,
          "calendarFeedEnabled": false,
          "canBeOrg": true,
          "canBePrivate": true,
          "canBePublic": true,
          "canInvite": true,
          "cardAging": "regular",
          "cardCovers": true,
          "comments": "members",
          "invitations": "members",
          "permissionLevel": "org",
          "selfJoin": false,
          "voting": "members"
        },
        "shortUrl": "https://trello.com/b/2nROp5bq",
        "url": "https://trello.com/b/2nROp5bq/transp-backend"
      }
      END_OF_JSON
    }

    subject { TrelloLeadTime::Board.for(board_id) }

    it "returns a board" do
      stub_request(:get, "https://api.trello.com/1/boards/#{board_id}?key=#{key}&token=#{token}").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => board_json, :headers => {})

      subject.should be_an_instance_of(TrelloLeadTime::Board)
    end

    it "should have a name" do
      stub_request(:get, "https://api.trello.com/1/boards/#{board_id}?key=#{key}&token=#{token}").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => board_json, :headers => {})

      subject.name.should == "Transparency Backend"
    end

  end
end
