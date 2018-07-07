premier_league = PremierLeague.find(14)

premier_league.match_days.each do | match_day |
  puts "Match day #{match_day.match_day_number}"
  match_day.matches.each do | match |
    puts "    #{match.home_team.name} vs #{match.away_team.name}"
    home_team_match_squad_stat = match.team_match_squad_stats.first
    if home_team_match_squad_stat.nil?
      home_team_match_squad_stat = TeamMatchSquadStat.create(team_id: match.home_team.id, match_id: match.id)
    else
      home_team_match_squad_stat.team_id = match.home_team.id
      puts home_team_match_squad_stat.valid?
      home_team_match_squad_stat.save
    end

    away_team_match_squad_stat = match.team_match_squad_stats.second
    if away_team_match_squad_stat.nil?
      away_team_match_squad_stat = TeamMatchSquadStat.create(team_id: match.away_team.id, match_id: match.id)
    else
      away_team_match_squad_stat.team_id = match.away_team.id
      away_team_match_squad_stat.save
    end    
  end
end