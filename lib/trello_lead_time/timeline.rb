module TrelloLeadTime
  class Timeline
    def self.for_trello_card(trello_card)
      Timeline.new(trello_card)
    end

    def initialize(trello_card)
      @trello_card = trello_card
    end

    def done?
      !last_done_action.nil?
    end

    def age_in_seconds
      @_age ||= calculate_age_in_seconds(creation_date, done_date)
    end

    def done_date
      last_done_action.date if !last_done_action.nil?
    end

    private

    def last_done_action
      @_last_done_action ||= actions.detect { |a| a.type =~ /updateCard/ && a.data.has_key?("listAfter") && a.data["listAfter"].has_key?("name") && a.data["listAfter"]["name"] =~ /Done/i }
    end

    def actions
      @_actions ||= filtered_actions
    end

    def filtered_actions
      @trello_card.actions(filter: 'createCard,updateCard:idList,updateCard:closed').map { |action| Action.from_trello_action(action) }
    end

    def creation_date
      return actions.last.date if actions.size > 0
      nil
    end

    def calculate_age_in_seconds(start_time, end_time)
      (end_time - start_time).round(0)
    end
  end
end
