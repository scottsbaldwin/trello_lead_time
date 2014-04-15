module TrelloLeadTime
  class TimeHumanizer
    def self.humanize_seconds(seconds)
      [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].inject([]){ |s, (count, name)|
        if seconds > 0
          seconds, n = seconds.divmod(count)
          s.unshift "#{n.to_i} #{name}"
        end
        s
      }.join(' ')
    end
  end
end
