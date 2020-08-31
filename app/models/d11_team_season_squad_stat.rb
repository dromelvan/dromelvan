class D11TeamSeasonSquadStat < ActiveRecord::Base
  include D11TeamSquadStat

  belongs_to :season, touch: true

  validates :season, presence: true

  MAX_TRANSFERS = 13

  def value
    PlayerSeasonInfo.where(d11_team: d11_team).where(season: season).pluck(:value).sum
  end

  def max_bid
    player_count = PlayerSeasonInfo.where(d11_team: d11_team).where(season: season).size
    if player_count < 11 then
      reserved = 5 * (11 - player_count)
      max_bid = 600 - value - reserved + 5
      max_bid
    else
      0
    end
  end

  def position_available(position)
    if d11_team.dummy?
      return true
    end
    count = PlayerSeasonInfo.where(d11_team: d11_team).where(season: season).where(position: position).size
    if position.id == 1
      return count < 1
    elsif position.id == 2 || position.id == 3 || position.id == 4
      return count < 4
    elsif position.id == 5
      return count < 2
    end
    return false
  end

  def position_available_count(position)
    count = PlayerSeasonInfo.where(d11_team: d11_team).where(season: season).where(position: position).size
    if position.id == 1
      return 1 - count
    elsif position.id == 2 || position.id == 3 || position.id == 4
      return 4 - count
    elsif position.id == 5
      return 2 - count
    end
    return 0
  end

  def player_match_stats
    PlayerMatchStat.by_d11_team(d11_team).by_season(season)
  end

  def transfer_count
    count = 0
    season.transfer_windows.each do |transfer_window|
      transfer_window.transfer_days.each do |transfer_day|
        count = count + transfer_day.transfer_listings.where(d11_team: d11_team).size
      end
    end
    return count
  end

  def remaining_transfers
    return MAX_TRANSFERS - transfer_count
  end

end
