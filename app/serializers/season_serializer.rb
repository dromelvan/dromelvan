class SeasonSerializer < BaseSerializer

  attributes :name

  has_one :premier_league
  
end