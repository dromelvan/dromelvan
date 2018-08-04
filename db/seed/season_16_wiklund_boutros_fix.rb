season = Season.current
wiklund = D11Team.find(37)
boutros = D11Team.find(29)

d11_team_registration = D11TeamRegistration.where(season: season, d11_team: wiklund).take
d11_team_registration.d11_team = boutros
d11_team_registration.save

d11_team_season_squad_stat = D11TeamSeasonSquadStat.where(season: season, d11_team: wiklund).take
d11_team_season_squad_stat.d11_team = boutros
d11_team_season_squad_stat.save

d11_league = season.d11_league
d11_league.d11_team_table_stats.where(d11_team: wiklund).each do |d11_team_table_stat|
  d11_team_table_stat.d11_team = boutros
  d11_team_table_stat.save
end

d11_match_day = d11_league.d11_match_days.first
d11_match_day.d11_matches.each do |d11_match|
  D11TeamTableStat.update_stats_from(d11_match) 
end
D11TeamTableStat.update_rankings_from(d11_match_day)  

d11_league.d11_match_days.each do |d11_match_dayy|
  d11_match = d11_match_dayy.d11_matches.where(home_d11_team: wiklund).first
  if !d11_match.nil?
    d11_match.home_d11_team = boutros
  else
    d11_match = d11_match_dayy.d11_matches.where(away_d11_team: wiklund).take
    d11_match.away_d11_team = boutros
  end
  d11_match.save
  
  d11_team_match_squad_stat = d11_match.d11_team_match_squad_stats.where(d11_team: wiklund).take
  d11_team_match_squad_stat.d11_team = boutros
  d11_team_match_squad_stat.save
end
