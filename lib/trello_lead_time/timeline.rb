require_relative 'array_searcher'

module TrelloLeadTime
  class Timeline
    include TrelloLeadTime::ArraySearcher

    def self.for_trello_card(trello_card)
      Timeline.new(trello_card)
    end

    def initialize(trello_card)
      @trello_card = trello_card
      assemble_timeline
    end

    def done?
      !last_done_action.nil?
    end

    def closed?
      !closed_date.nil?
    end

    def closed_date
      action = actions.detect {|a| a.type =~ /updateCard/i && a.data["old"].has_key?("closed")}
      action ? action.date : nil
    end

    def age_in_seconds
      @_age ||= calculate_age_in_seconds(creation_date, done_date)
    end

    def done_date
      last_done_action.date if !last_done_action.nil?
    end

    def seconds_in_list(list_name)
      matched_list = @_seconds_in_list.values.detect { |list| element_matches_expression?(list[:list_name], list_name) }
      return matched_list[:seconds_in_list] if !matched_list.nil?
      0
    end

    private

    def last_done_action
      @_last_done_action ||= actions.detect { |a| a.type =~ /updateCard/ && a.data.has_key?("listAfter") && a.data["listAfter"].has_key?("name") && a.data["listAfter"]["name"] =~ Config.list_name_matcher_for_done }
    end

    def actions
      @_actions ||= filtered_actions
    end

    def filtered_actions
      @trello_card.actions(filter: 'copyCard,moveCardToBoard,createCard,updateCard:idList,updateCard:closed').map { |action| Action.from_trello_action(action) }
    end

    def creation_date
      return actions.last.date if actions.size > 0
      nil
    end

    def calculate_age_in_seconds(start_time, end_time)
      return 0 unless start_time && end_time
      (end_time - start_time).round(0)
    end

    def assemble_timeline
      @_seconds_in_list = {}
      actions.reverse.each_with_index do |action, index|
        before_list = list_before_current_index(index)
        after_list = list_from_result_of_action(action)
        seconds = time_since_last_action(index)

        list_identifier = before_list["id"]
        if list_identifier
          if !@_seconds_in_list.has_key?(list_identifier)
            @_seconds_in_list[list_identifier] = {
              list_id: before_list["id"],
              list_name: before_list["name"],
              seconds_in_list: 0
            }
          end
          @_seconds_in_list[list_identifier][:seconds_in_list] += seconds
        end

        if index == actions.length - 1
          # we won't have an after_list if the card was closed after being
          # created and left in a single list
          if after_list
            list_identifier = after_list["id"]
            if !@_seconds_in_list.has_key?(list_identifier)
              @_seconds_in_list[list_identifier] = {
                list_id: after_list["id"],
                list_name: after_list["name"],
                seconds_in_list: 0
              }
            end

            seconds = 0
            if done?
              seconds = calculate_age_in_seconds(action.date, done_date)
            elsif closed?
              seconds = calculate_age_in_seconds(action.date, closed_date)
            else
              seconds = calculate_age_in_seconds(action.date, Time.now)
            end
            @_seconds_in_list[list_identifier][:seconds_in_list] += seconds
          end
        end

      end
    end

    def list_before_current_index(current_index)
      if current_index == 0
        "?"
      else
        list = nil
        current_index.downto(1) do |i|
          list = list_from_result_of_action(actions.reverse[i - 1])
          break if list
        end
        list
      end
    end

    def list_from_result_of_action(action)
      if %w{createCard copyCard moveCardToBoard}.include?(action.type)
        action.data["list"]
      elsif action.type == "updateCard" && action.data.has_key?("old") && action.data["old"].has_key?("idList")
        action.data["listAfter"]
      end
    end

    def time_since_last_action(current_index)
      if current_index == 0
        0
      else
        acts = actions.reverse
        current_date = acts[current_index].date
        previous_date = acts[current_index - 1].date
        (current_date - previous_date).round(0)
      end
    end

  end
end
