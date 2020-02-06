# 'Manually' insert new transfer day after we've done a live auction transfer day

transfer_day = TransferDay.current
transfer_day.status = :finished
transfer_day.save

transfer_day = TransferDay.create(transfer_window: transfer_day.transfer_window, transfer_day_number: transfer_day.transfer_day_number + 1, status: :active, datetime: transfer_day.datetime + 1.day)

season = Season.current

PlayerSeasonInfo.joins(:team).joins(:d11_team).where(season: season, teams: { dummy: false}, d11_teams: { dummy: true}).each do |player_season_info|
  transfer_listing = TransferListing.new(transfer_day: transfer_day, player: player_season_info.player, team: player_season_info.team, d11_team: player_season_info.d11_team, position: player_season_info.position, new_player: false)
  player_season_stat = player_season_info.player.season_stat(player_season_info.season)
  transfer_listing.init_from(player_season_stat)
  transfer_listing.save
end
