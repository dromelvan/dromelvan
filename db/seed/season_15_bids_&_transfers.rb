d11_team_ranking = 1
player_ranking = 1
D11TeamSeasonSquadStat.where(season_id: 15).each do | d11_team_season_squad_stat |
  puts "Handling #{d11_team_season_squad_stat.d11_team.name}"
  PlayerSeasonInfo.where(d11_team: d11_team_season_squad_stat.d11_team, season: d11_team_season_squad_stat.season).each do | player_season_info |
    puts "    #{player_season_info.player.name} #{player_season_info.value} #{d11_team_ranking} #{player_ranking}"
    #TransferBid.create(transfer_day_id: 84, player_id: player_season_info.player.id, player_ranking: player_ranking, d11_team_id: d11_team_season_squad_stat.d11_team_id, d11_team_ranking: d11_team_ranking, fee: player_season_info.value, active_fee: player_season_info.value, successful: true)
    #Transfer.create(transfer_day_id: 84, player_id: player_season_info.player.id, d11_team_id: d11_team_season_squad_stat.d11_team_id, fee: player_season_info.value)
    player_ranking += 1
  end
  d11_team_ranking += 1
end
