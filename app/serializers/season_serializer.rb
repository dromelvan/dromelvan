class SeasonSerializer < BaseSerializer

  attributes :name

  has_one :premier_league
  has_many :d11_teams
  has_many :d11_match_days

  private
    def d11_teams
      d11_teams = []
      object.d11_team_registrations.each do |d11_team_registration|
        d11_teams << d11_team_registration.d11_team
      end
      d11_teams
    end
    
    def d11_match_days
      object.d11_league.d11_match_days
    end
    
end