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

    def total_lead_time
      times = done_or_closed_cards.collect(&:lead_time)
      total(times)
    end

    def average_lead_time
      times = done_or_closed_cards.collect(&:lead_time)
      average(times)
    end

    def total_queue_time
      times = done_or_closed_cards.collect(&:queue_time)
      total(times)
    end

    def average_queue_time
      times = done_or_closed_cards.collect(&:queue_time)
      average(times)
    end

    def total_cycle_time
      times = done_or_closed_cards.collect(&:cycle_time)
      total(times)
    end

    def average_cycle_time
      times = done_or_closed_cards.collect(&:cycle_time)
      average(times)
    end

    def total_age
      times = done_or_closed_cards.collect(&:age_in_seconds)
      total(times)
    end

    def average_age
      times = done_or_closed_cards.collect(&:age_in_seconds)
      average(times)
    end

    private

    def done_or_closed_cards
      @_done_or_closed_cards ||= cards.select { |c| c.done? || c.closed? }
    end

    def cards
      @_cards ||= @trello_list.cards.map { |c| TrelloLeadTime::Card.from_trello_card(c) }
    end

    def total(times)
      times.inject(0) { |sum, el| sum + el }
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
