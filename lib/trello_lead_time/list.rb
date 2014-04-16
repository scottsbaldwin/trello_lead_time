module TrelloLeadTime
  class List
    def self.from_trello_list(list)
      List.new(list)
    end

    def initialize(list)
      @trello_list = list
    end

    def name
      @trello_list.name
    end

    def average_age
      calculate_average_age_of_cards
    end

    def average_lead_time
      calculate_average_lead_time_of_cards
    end

    def average_queue_time
      calculate_average_queue_time_of_cards
    end

    def average_cycle_time
      calculate_average_cycle_time_of_cards
    end

    private

    def done_or_closed_cards
      @_done_or_closed_cards ||= cards.select { |c| c.done? || c.closed? }
    end

    def cards
      @_cards ||= @trello_list.cards.map { |c| TrelloLeadTime::Card.from_trello_card(c) }
    end

    def calculate_average_age_of_cards
      times = done_or_closed_cards.map { |c| c.age_in_seconds }
      average(times)
    end

    def calculate_average_lead_time_of_cards
      times = done_or_closed_cards.map { |c| c.lead_time }
      average(times)
    end

    def calculate_average_queue_time_of_cards
      times = done_or_closed_cards.map { |c| c.queue_time }
      average(times)
    end

    def calculate_average_cycle_time_of_cards
      times = done_or_closed_cards.map { |c| c.cycle_time }
      average(times)
    end

    def average(times)
      avg = 0.0
      if times.size > 0
        avg = (times.inject(0.0) { |sum, el| sum + el } / times.size).round(0)
      end
      avg
    end
  end
end
