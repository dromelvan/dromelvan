class MatchSerializer < BaseSerializer

  attributes :whoscored_id, :datetime, :status, :match_day_number, :season_name

  private
    def status
      if object.pending?
        0
      elsif object.active?
        1
      elsif object.finished?
        2
      elsif object.full_time?
        3
      end
    end
    
    def season_name
      object.match_day.premier_league.season.name
    end  

    def match_day_number
      object.match_day.match_day_number
    end
end