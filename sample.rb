require 'trello_lead_time'

developer_public_key       = 'YOUR TRELLO PUBLIC KEY'
member_token               = 'YOUR TRELLO MEMBER TOKEN'
organization_name          = 'fogcreek'
board_url                  = 'https://trello.com/b/nC8QJJoZ/trello-development'
source_lists               = ['Live (4/8)', 'Live (3/17)', 'Live (3/3)', 'Live (2/11)', 'Live (1/14)']
queue_time_lists           = ['Next Up']
cycle_time_lists           = ['In Progress', 'Testing']
list_name_matcher_for_done = /^Live/

TrelloLeadTime.configure do |cfg|
  cfg.organization_name = organization_name
  cfg.set_trello_key_and_token(developer_public_key, member_token)
  cfg.queue_time_lists = queue_time_lists
  cfg.cycle_time_lists = cycle_time_lists
  cfg.list_name_matcher_for_done = list_name_matcher_for_done
end

puts "-" * 40
puts "Calculating metrics for:"
puts "#{board_url}"
puts "-" * 40

board = TrelloLeadTime::Board.from_url board_url

source_lists.each do |source_list|
  totals   = board.totals(source_list)
  averages = board.averages(source_list)

  puts "Using cards in list: #{source_list}"
  puts "\tAverage Card Age:   #{TrelloLeadTime::TimeHumanizer.humanize_seconds(averages[:age][:overall])}"
  puts "\tAverage Lead Time:  #{TrelloLeadTime::TimeHumanizer.humanize_seconds(averages[:lead_time][:overall])}"
  puts "\tAverage Queue Time: #{TrelloLeadTime::TimeHumanizer.humanize_seconds(averages[:queue_time][:overall])}"
  puts "\tAverage Cycle Time: #{TrelloLeadTime::TimeHumanizer.humanize_seconds(averages[:lead_time][:overall])}"
  puts ""
  puts "\tTotal Card Age:     #{TrelloLeadTime::TimeHumanizer.humanize_seconds(totals[:age][:overall])}"
  puts "\tTotal Lead Time:    #{TrelloLeadTime::TimeHumanizer.humanize_seconds(totals[:lead_time][:overall])}"
  puts "\tTotal Queue Time:   #{TrelloLeadTime::TimeHumanizer.humanize_seconds(totals[:queue_time][:overall])}"
  puts "\tTotal Cycle Time:   #{TrelloLeadTime::TimeHumanizer.humanize_seconds(totals[:lead_time][:overall])}"
  puts ""
end
