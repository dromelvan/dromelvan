class MatchSerializer < BaseSerializer

  attributes :whoscored_id, :datetime, :match_day_number, :season_name

  private
    def season_name
      object.match_day.premier_league.season.name
    end  

    def match_day_number
      object.match_day.match_day_number
    end
end