team_table_stats = [
  [ 2, 1 ],
  [ 3, 1 ],
  [ 4, 1 ],
  [ 5, 1 ],
  [ 6, 1 ],
  [ 7, 1 ],
  [ 8, 1 ],
  [ 9, 1 ],
  [ 10, 1 ],
  [ 11, 1 ],
  [ 12, 1 ],
  [ 13, 1 ],
  [ 14, 1 ],
  [ 15, 1 ],
  [ 16, 1 ],
  [ 17, 1 ],
  [ 18, 1 ],
  [ 19, 1 ],
  [ 20, 1 ],
  [ 21, 1 ],
  [ 2, 2 ],
  [ 3, 2 ],
  [ 4, 2 ],
  [ 5, 2 ],
  [ 6, 2 ],
  [ 7, 2 ],
  [ 9, 2 ],
  [ 10, 2 ],
  [ 12, 2 ],
  [ 14, 2 ],
  [ 15, 2 ],
  [ 16, 2 ],
  [ 17, 2 ],
  [ 18, 2 ],
  [ 19, 2 ],
  [ 20, 2 ],
  [ 21, 2 ],
  [ 22, 2 ],
  [ 23, 2 ],
  [ 24, 2 ],
  [ 2, 3 ],
  [ 3, 3 ],
  [ 4, 3 ],
  [ 5, 3 ],
  [ 6, 3 ],
  [ 7, 3 ],
  [ 9, 3 ],
  [ 10, 3 ],
  [ 12, 3 ],
  [ 13, 3 ],
  [ 14, 3 ],
  [ 15, 3 ],
  [ 16, 3 ],
  [ 17, 3 ],
  [ 18, 3 ],
  [ 20, 3 ],
  [ 22, 3 ],
  [ 24, 3 ],
  [ 25, 3 ],
  [ 26, 3 ],
  [ 2, 4 ],
  [ 3, 4 ],
  [ 4, 4 ],
  [ 5, 4 ],
  [ 6, 4 ],
  [ 7, 4 ],
  [ 9, 4 ],
  [ 10, 4 ],
  [ 14, 4 ],
  [ 15, 4 ],
  [ 16, 4 ],
  [ 17, 4 ],
  [ 18, 4 ],
  [ 20, 4 ],
  [ 22, 4 ],
  [ 23, 4 ],
  [ 24, 4 ],
  [ 25, 4 ],
  [ 27, 4 ],
  [ 28, 4 ],
  [ 2, 5 ],
  [ 3, 5 ],
  [ 4, 5 ],
  [ 5, 5 ],
  [ 7, 5 ],
  [ 9, 5 ],
  [ 10, 5 ],
  [ 14, 5 ],
  [ 15, 5 ],
  [ 16, 5 ],
  [ 17, 5 ],
  [ 19, 5 ],
  [ 20, 5 ],
  [ 21, 5 ],
  [ 23, 5 ],
  [ 24, 5 ],
  [ 25, 5 ],
  [ 30, 5 ],
  [ 34, 5 ],
  [ 35, 5 ],
  [ 2, 6 ],
  [ 3, 6 ],
  [ 4, 6 ],
  [ 5, 6 ],
  [ 7, 6 ],
  [ 9, 6 ],
  [ 10, 6 ],
  [ 15, 6 ],
  [ 19, 6 ],
  [ 20, 6 ],
  [ 21, 6 ],
  [ 22, 6 ],
  [ 24, 6 ],
  [ 25, 6 ],
  [ 26, 6 ],
  [ 30, 6 ],
  [ 34, 6 ],
  [ 35, 6 ],
  [ 36, 6 ],
  [ 14, 6 ],
  [ 2, 7 ],
  [ 3, 7 ],
  [ 22, 7 ],
  [ 4, 7 ],
  [ 37, 7 ],
  [ 5, 7 ],
  [ 7, 7 ],
  [ 9, 7 ],
  [ 10, 7 ],
  [ 14, 7 ],
  [ 24, 7 ],
  [ 15, 7 ],
  [ 17, 7 ],
  [ 35, 7 ],
  [ 19, 7 ],
  [ 20, 7 ],
  [ 23, 7 ],
  [ 21, 7 ],
  [ 30, 7 ],
  [ 26, 7 ],
  [ 2, 8 ],
  [ 3, 8 ],
  [ 4, 8 ],
  [ 5, 8 ],
  [ 7, 8 ],
  [ 9, 8 ],
  [ 10, 8 ],
  [ 15, 8 ],
  [ 17, 8 ],
  [ 19, 8 ],
  [ 20, 8 ],
  [ 23, 8 ],
  [ 24, 8 ],
  [ 26, 8 ],
  [ 27, 8 ],
  [ 30, 8 ],
  [ 14, 8 ],
  [ 35, 8 ],
  [ 38, 8 ],
  [ 39, 8 ],
  [ 2, 9 ],
  [ 3, 9 ],
  [ 39, 9 ],
  [ 18, 9 ],
  [ 32, 9 ],
  [ 7, 9 ],
  [ 9, 9 ],
  [ 10, 9 ],
  [ 14, 9 ],
  [ 24, 9 ],
  [ 15, 9 ],
  [ 17, 9 ],
  [ 35, 9 ],
  [ 19, 9 ],
  [ 20, 9 ],
  [ 23, 9 ],
  [ 21, 9 ],
  [ 30, 9 ],
  [ 38, 9 ],
  [ 27, 9 ],
  [ 2, 10 ],
  [ 3, 10 ],
  [ 39, 10 ],
  [ 18, 10 ],
  [ 7, 10 ],
  [ 9, 10 ],
  [ 10, 10 ],
  [ 14, 10 ],
  [ 24, 10 ],
  [ 15, 10 ],
  [ 17, 10 ],
  [ 35, 10 ],
  [ 19, 10 ],
  [ 20, 10 ],
  [ 23, 10 ],
  [ 21, 10 ],
  [ 27, 10 ],
  [ 34, 10 ],
  [ 28, 10 ],
  [ 40, 10 ]
]

puts("Seeding team_table_stats...")

team_table_stats.each do | team_id, premier_league_id |
  premier_league = PremierLeague.find(premier_league_id)
  premier_league.match_days.each do |match_day|
    TeamTableStat.create(team_id: team_id, premier_league_id: premier_league_id, match_day_id: match_day.id)
  end
end

puts("Updating team_table_stats...")

PremierLeague.all.each do |premier_league|
  match_day = premier_league.match_days.first
  match_day.matches.each do |match|
    TeamTableStat.update_stats_from(match) 
  end
  TeamTableStat.update_rankings_from(match_day)  
end
