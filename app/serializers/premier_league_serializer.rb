class PremierLeagueSerializer < BaseSerializer

  attributes :name

  has_many :match_days
  
end