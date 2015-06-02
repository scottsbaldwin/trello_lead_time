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

    def short_url
      @trello_card.short_url
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

    def lead_time
      @_lead_time ||= queue_time + cycle_time
    end

    def queue_time
      @_queue_time ||= sum_of_times_in_lists(Config.queue_time_lists)
    end

    def cycle_time
      @_cycle_time ||= sum_of_times_in_lists(Config.cycle_time_lists)
    end

    def has_label_name?(name)
      match = labels.find { |l| l.name =~ /^#{Regexp.quote(name)}$/i }
      !match.nil?
    end

    def has_label_color?(color)
      match = labels.find { |l| l.color =~ /^#{Regexp.quote(color)}$/i }
      !match.nil?
    end

    def hash_tags
      comments_with_tags = comments.select { |comment| comment =~ /^#(.+)$/ } || []
      tags = []
      comments_with_tags.each do |comment|
        tags.concat(comment.split.find_all { |word| /^#.+/.match(word) })
      end
      tags
    end

    def labels
      @_labels ||= @trello_card.labels.map { |label| OpenStruct.new({name: label.name, color: label.color}) }
    end

    private

    def sum_of_times_in_lists(lists)
      lists.inject(0) { |sum, list_name| sum + @timeline.seconds_in_list(list_name) }
    end

    def comments
      @_comments ||= @trello_card.actions(filter:"commentCard").map { |comment| comment.data['text'] }
    end

  end
end
