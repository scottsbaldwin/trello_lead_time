module TrelloLeadTime
  class Card
    def self.from_trello_card(trello_card)
      Card.new(trello_card)
    end

    def initialize(trello_card)
      @trello_card = trello_card
      @timeline = Timeline.for_trello_card(trello_card)
    end

    def name
      @trello_card.name
    end

    def done?
      @timeline.done?
    end

    def closed?
      @trello_card.closed
    end

    def age_in_seconds
      @timeline.age_in_seconds
    end

    def queue_time
      @_queue_time ||= sum_of_times_in_lists(Config.queue_time_lists)
    end

    def cycle_time
      @_cycle_time ||= sum_of_times_in_lists(Config.cycle_time_lists)
    end

    private

    def sum_of_times_in_lists(lists)
      lists.inject(0) { |sum, list_name| sum + @timeline.seconds_in_list(list_name) }
    end

  end
end
