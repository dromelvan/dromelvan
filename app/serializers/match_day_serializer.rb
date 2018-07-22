class MatchDaySerializer < BaseSerializer

  attributes :match_day_number

  has_many :matches

end