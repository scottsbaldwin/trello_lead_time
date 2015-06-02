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

    def breakdown_by_labels(labels)
      times = default_breakdown_by_labels(labels)

      done_or_closed_cards.each do |card|
        matches = labels & card.labels.map(&:name)
        matches.each do |label|
          times[:total][:lead_time][label] += card.lead_time
          times[:total][:queue_time][label] += card.queue_time
          times[:total][:cycle_time][label] += card.cycle_time
          times[:total][:age][label] += card.age_in_seconds

          times[:average][:lead_time][label] << card.lead_time
          times[:average][:queue_time][label] << card.queue_time
          times[:average][:cycle_time][label] << card.cycle_time
          times[:average][:age][label] << card.age_in_seconds
        end
      end

      labels.each do |label|
        times[:average][:lead_time][label]  = average(times[:average][:lead_time][label])
        times[:average][:queue_time][label] = average(times[:average][:queue_time][label])
        times[:average][:cycle_time][label] = average(times[:average][:cycle_time][label])
        times[:average][:age][label]        = average(times[:average][:age][label])
      end

      times
    end

    def breakdown_by_tags
      times = default_breakdown_by_tags
      all_tags = []

      done_or_closed_cards.each do |card|
        all_tags.concat(card.hash_tags)
        card.hash_tags.each do |tag|
          times[:total][:lead_time][tag] = 0 unless times[:total][:lead_time][tag]
          times[:total][:lead_time][tag] += card.lead_time

          times[:total][:queue_time][tag] = 0 unless times[:total][:queue_time][tag]
          times[:total][:queue_time][tag] += card.queue_time

          times[:total][:cycle_time][tag] = 0 unless times[:total][:cycle_time][tag]
          times[:total][:cycle_time][tag] += card.cycle_time

          times[:total][:age][tag] = 0 unless times[:total][:age][tag]
          times[:total][:age][tag] += card.age_in_seconds

          times[:average][:lead_time][tag] = [] unless times[:average][:lead_time][tag]
          times[:average][:lead_time][tag] << card.lead_time

          times[:average][:queue_time][tag] = [] unless times[:average][:queue_time][tag]
          times[:average][:queue_time][tag] << card.queue_time

          times[:average][:cycle_time][tag] = [] unless times[:average][:cycle_time][tag]
          times[:average][:cycle_time][tag] << card.cycle_time

          times[:average][:age][tag] = [] unless times[:average][:age][tag]
          times[:average][:age][tag] << card.age_in_seconds
        end
      end

      all_tags.uniq.each do |tag|
        times[:average][:lead_time][tag]  = average(times[:average][:lead_time][tag])
        times[:average][:queue_time][tag] = average(times[:average][:queue_time][tag])
        times[:average][:cycle_time][tag] = average(times[:average][:cycle_time][tag])
        times[:average][:age][tag]        = average(times[:average][:age][tag])
      end
      times
    end

    def done_or_closed_cards
      @_done_or_closed_cards ||= cards.select { |c| c.done? || c.closed? }
    end

    private

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

    def default_breakdown_by_labels(labels)
      times = {
        total: { lead_time: {}, queue_time: {}, cycle_time: {}, age: {} },
        average: { lead_time: {}, queue_time: {}, cycle_time: {}, age: {} }
      }
      labels.each do |label|
        times[:total][:lead_time][label]  = 0
        times[:total][:queue_time][label] = 0
        times[:total][:cycle_time][label] = 0
        times[:total][:age][label]        = 0

        times[:average][:lead_time][label]  = []
        times[:average][:queue_time][label] = []
        times[:average][:cycle_time][label] = []
        times[:average][:age][label]        = []
      end
      times
    end

    def default_breakdown_by_tags
      times = {
        total: { lead_time: {}, queue_time: {}, cycle_time: {}, age: {} },
        average: { lead_time: {}, queue_time: {}, cycle_time: {}, age: {} }
      }
      times
    end

  end
end
