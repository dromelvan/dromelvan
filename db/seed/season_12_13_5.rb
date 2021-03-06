puts("Seeding player_match_stats goals conceded...")

count = 0
PlayerMatchStat.where("position_id = 1 and match_id >= 3802").each do |player_match_stat|
  if player_match_stat.participated? then
    match = player_match_stat.match
    team = player_match_stat.team
    goals = match.goals_against(team)
    if goals > 0 then
       player_match_stat.goals_conceded = goals       
    end
  else
    player_match_stat.goals_conceded = 0
  end  
  player_match_stat.save
  count = count + 1
  puts("#{count}")
end

count = 0
PlayerMatchStat.where("position_id = 2 and match_id >= 3802").each do |player_match_stat|
  if player_match_stat.participated? then
    match = player_match_stat.match
    team = player_match_stat.team
    goals = match.goals_against(team)
    if goals > 0 then
       player_match_stat.goals_conceded = goals       
    end
  else
    player_match_stat.goals_conceded = 0
  end  
  player_match_stat.save
  count = count + 1
  puts("#{count}")
end

count = 0
PlayerMatchStat.where("position_id = 3 and match_id >= 3802").each do |player_match_stat|
  if player_match_stat.participated? then
    match = player_match_stat.match
    team = player_match_stat.team
    goals = match.goals_against(team)
    if goals > 0 then
       player_match_stat.goals_conceded = goals       
    end
  else
    player_match_stat.goals_conceded = 0
  end  
  player_match_stat.save
  count = count + 1
  puts("#{count}")
end

count = 0
PlayerMatchStat.where("position_id = 4 and match_id >= 3802").each do |player_match_stat|
  player_match_stat.goals_conceded = 0
  player_match_stat.save
  count = count + 1
  puts("#{count}")
end

count = 0
PlayerMatchStat.where("position_id = 5 and match_id >= 3802").each do |player_match_stat|
  player_match_stat.goals_conceded = 0
  player_match_stat.save
  count = count + 1
  puts("#{count}")
end

puts("Updating player stats and rankings...")

[Season.find(12), Season.find(13)].each do |season|
  season.player_season_stats.each do |player_season_stat|
    player_season_stat.save
  end
  PlayerSeasonStat.update_rankings(season)
end

puts("Updating player career stats and rankings...")

PlayerCareerStat.all.each do |player_career_stat|
  player_career_stat.save
end

PlayerCareerStat.update_rankings

puts("Updating team match squad stats...")

TeamMatchSquadStat.where("match_id >= 3802").each do |team_match_squad_stat|
  team_match_squad_stat.save
end

puts("Updating team season squad stats...")

TeamSeasonSquadStat.where("season_id >= 12").each do |team_season_squad_stat|
  team_season_squad_stat.save
end

puts("Updating team career squad stats...")

TeamCareerSquadStat.all.each do |team_career_squad_stat|
  team_career_squad_stat.save
end

d11_matches = [
  [382,29,43,20,19],
  [382,37,33,15,-1],
  [382,48,32,9,13],
  [382,24,42,8,17],
  [382,45,31,17,6],
  [382,41,18,4,18],
  [382,2,16,4,20],
  [382,7,13,14,0],
  [382,4,3,16,21],
  [382,34,12,8,9],
  [383,18,29,1,6],
  [383,12,37,17,3],
  [383,45,34,20,14],
  [383,16,41,4,10],
  [383,31,32,9,10],
  [383,33,24,16,14],
  [383,3,7,21,14],
  [383,43,48,16,21],
  [383,13,2,23,5],
  [383,42,4,12,10],
  [384,24,12,6,23],
  [384,34,31,5,20],
  [384,4,33,23,19],
  [384,7,42,29,6],
  [384,2,3,19,-6],
  [384,48,18,8,27],
  [384,32,43,16,25],
  [384,37,45,8,12],
  [384,29,16,1,11],
  [384,41,13,5,5],
  [385,45,24,16,14],
  [385,31,43,17,16],
  [385,42,2,10,1],
  [385,12,4,4,16],
  [385,34,37,-6,33],
  [385,18,32,4,18],
  [385,3,41,16,-3],
  [385,33,7,11,33],
  [385,16,48,11,24],
  [385,13,29,-5,13],
  [386,2,33,-2,14],
  [386,29,3,10,-3],
  [386,32,16,-5,3],
  [386,24,34,15,-5],
  [386,4,45,-2,15],
  [386,43,18,9,19],
  [386,41,42,15,14],
  [386,48,13,21,8],
  [386,7,12,29,10],
  [386,37,31,1,3],
  [387,3,48,19,31],
  [387,45,7,31,20],
  [387,13,32,7,11],
  [387,12,2,12,10],
  [387,34,4,9,12],
  [387,16,43,0,10],
  [387,42,29,10,7],
  [387,31,18,2,11],
  [387,37,24,4,15],
  [387,33,41,15,7],
  [388,48,42,13,9],
  [388,7,34,12,18],
  [388,2,45,16,20],
  [388,18,16,36,5],
  [388,41,12,19,14],
  [388,43,13,34,16],
  [388,24,31,24,1],
  [388,29,33,8,-1],
  [388,32,3,17,19],
  [388,4,37,23,6],
  [389,3,43,33,12],
  [389,42,32,8,13],
  [389,33,48,31,16],
  [389,12,29,32,24],
  [389,31,16,11,-1],
  [389,45,41,1,6],
  [389,24,4,19,5],
  [389,37,7,21,2],
  [389,34,2,-2,3],
  [389,13,18,1,12],
  [390,16,13,7,11],
  [390,29,45,14,9],
  [390,7,24,24,11],
  [390,4,31,3,14],
  [390,18,3,16,15],
  [390,43,42,6,8],
  [390,48,12,31,7],
  [390,2,37,24,8],
  [390,41,34,11,1],
  [390,32,33,10,8],
  [391,33,43,32,2],
  [391,3,16,20,17],
  [391,12,32,24,9],
  [391,45,48,4,34],
  [391,34,29,9,11],
  [391,31,13,19,9],
  [391,42,18,21,9],
  [391,37,41,16,3],
  [391,24,2,12,19],
  [391,4,7,3,14],
  [392,7,31,23,9],
  [392,48,34,17,8],
  [392,2,4,24,9],
  [392,29,37,3,8],
  [392,43,12,1,0],
  [392,18,33,6,40],
  [392,16,42,7,12],
  [392,13,3,8,37],
  [392,41,24,17,9],
  [392,32,45,5,-5],
  [393,24,29,11,20],
  [393,34,32,15,5],
  [393,37,48,10,24],
  [393,12,18,3,-5],
  [393,31,3,-1,12],
  [393,42,13,18,13],
  [393,7,2,8,11],
  [393,45,43,5,26],
  [393,33,16,19,1],
  [393,4,41,3,10],
  [394,32,37,10,2],
  [394,48,24,-1,10],
  [394,41,7,11,15],
  [394,2,31,22,24],
  [394,16,12,17,16],
  [394,43,34,10,5],
  [394,18,45,19,11],
  [394,13,33,16,-4],
  [394,29,4,6,10],
  [394,3,42,22,22],
  [395,4,48,14,10],
  [395,2,41,14,5],
  [395,7,29,14,6],
  [395,33,3,2,34],
  [395,12,13,20,16],
  [395,37,43,2,4],
  [395,45,16,12,18],
  [395,31,42,8,17],
  [395,34,18,23,14],
  [395,24,32,8,20],
  [396,42,33,10,3],
  [396,13,45,18,-8],
  [396,41,31,25,6],
  [396,16,34,34,12],
  [396,18,37,25,0],
  [396,3,12,14,13],
  [396,43,24,27,27],
  [396,32,4,19,16],
  [396,48,7,26,8],
  [396,29,2,11,24],
  [397,7,32,11,24],
  [397,24,18,16,10],
  [397,37,16,9,17],
  [397,34,13,12,14],
  [397,31,33,9,11],
  [397,12,42,20,30],
  [397,2,48,8,38],
  [397,4,43,14,8],
  [397,45,3,3,20],
  [397,41,29,20,12],
  [398,43,7,24,15],
  [398,18,4,6,39],
  [398,16,24,17,32],
  [398,13,37,12,3],
  [398,32,2,15,57],
  [398,48,41,12,24],
  [398,29,31,12,4],
  [398,33,12,6,24],
  [398,42,45,14,13],
  [398,3,34,7,19],
  [399,29,48,1,24],
  [399,31,12,6,21],
  [399,45,33,10,2],
  [399,34,42,2,9],
  [399,37,3,10,6],
  [399,24,13,10,12],
  [399,7,18,30,21],
  [399,2,43,32,19],
  [399,41,32,14,14],
  [399,4,16,30,9],
  [400,43,41,26,12],
  [400,32,29,7,-1],
  [400,16,7,17,18],
  [400,13,4,18,37],
  [400,18,2,20,15],
  [400,48,31,20,10],
  [400,3,24,11,21],
  [400,42,37,12,14],
  [400,12,45,4,-2],
  [400,33,34,11,21],
  [401,31,45,3,-1],
  [401,33,37,13,-1],
  [401,42,24,30,6],
  [401,43,29,5,5],
  [401,32,48,19,22],
  [401,3,4,7,13],
  [401,18,41,-3,21],
  [401,16,2,17,27],
  [401,13,7,8,25],
  [401,12,34,38,8],
  [402,37,12,16,22],
  [402,7,3,15,7],
  [402,34,45,7,13],
  [402,41,16,10,13],
  [402,48,43,29,14],
  [402,32,31,2,11],
  [402,29,18,16,8],
  [402,4,42,13,14],
  [402,24,33,11,16],
  [402,2,13,15,0],
  [403,31,34,19,24],
  [403,33,4,14,25],
  [403,45,37,15,2],
  [403,43,32,1,6],
  [403,18,48,13,22],
  [403,3,2,21,0],
  [403,42,7,26,21],
  [403,13,41,6,0],
  [403,16,29,8,26],
  [403,12,24,9,20],
  [404,2,42,2,7],
  [404,24,45,42,23],
  [404,29,13,1,11],
  [404,37,34,34,15],
  [404,32,18,23,13],
  [404,43,31,16,17],
  [404,4,12,20,24],
  [404,7,33,1,38],
  [404,41,3,23,15],
  [404,48,16,-5,2],
  [405,45,4,21,17],
  [405,31,37,30,4],
  [405,16,32,8,16],
  [405,18,43,10,11],
  [405,13,48,10,11],
  [405,34,24,17,16],
  [405,42,41,14,0],
  [405,12,7,21,3],
  [405,3,29,17,15],
  [405,33,2,10,13],
  [406,4,34,14,15],
  [406,43,16,14,15],
  [406,32,13,12,5],
  [406,18,31,13,10],
  [406,24,37,14,14],
  [406,7,45,18,21],
  [406,2,12,5,10],
  [406,29,42,13,21],
  [406,48,3,15,16],
  [406,41,33,19,9],
  [407,42,48,5,17],
  [407,13,43,4,-1],
  [407,33,29,-7,-2],
  [407,12,41,26,11],
  [407,3,32,17,17],
  [407,34,7,7,5],
  [407,37,4,4,35],
  [407,31,24,15,22],
  [407,16,18,4,13],
  [407,45,2,27,22],
  [408,48,33,25,35],
  [408,18,13,6,4],
  [408,43,3,11,7],
  [408,29,12,0,26],
  [408,41,45,0,23],
  [408,2,34,15,32],
  [408,16,31,7,1],
  [408,32,42,18,10],
  [408,7,37,20,10],
  [408,4,24,19,19],
  [409,3,18,11,32],
  [409,13,16,21,21],
  [409,33,32,18,24],
  [409,42,43,10,5],
  [409,24,7,22,29],
  [409,12,48,20,43],
  [409,31,4,10,26],
  [409,34,41,9,6],
  [409,45,29,24,5],
  [409,37,2,-1,22],
  [410,29,34,8,21],
  [410,7,4,24,21],
  [410,2,24,4,3],
  [410,41,37,15,19],
  [410,48,45,9,15],
  [410,43,33,15,-7],
  [410,13,31,1,27],
  [410,32,12,10,12],
  [410,18,42,16,29],
  [410,16,3,11,27],
  [411,12,43,34,5],
  [411,4,2,18,32],
  [411,33,18,6,11],
  [411,42,16,3,7],
  [411,24,41,19,5],
  [411,34,48,26,21],
  [411,37,29,8,5],
  [411,3,13,13,13],
  [411,45,32,14,13],
  [411,31,7,13,16],
  [412,16,33,19,7],
  [412,2,7,26,13],
  [412,41,4,9,19],
  [412,29,24,0,22],
  [412,48,37,20,20],
  [412,32,34,15,12],
  [412,43,45,27,19],
  [412,18,12,3,6],
  [412,3,31,18,20],
  [412,13,42,18,10],
  [413,4,29,18,8],
  [413,31,2,32,16],
  [413,37,32,2,14],
  [413,45,18,16,8],
  [413,33,13,-1,14],
  [413,12,16,6,22],
  [413,7,41,38,27],
  [413,24,48,13,13],
  [413,42,3,4,26],
  [413,34,43,12,4],
  [414,16,45,30,12],
  [414,29,7,4,19],
  [414,32,24,19,23],
  [414,43,37,38,23],
  [414,42,31,22,19],
  [414,3,33,18,7],
  [414,13,12,10,26],
  [414,18,34,2,4],
  [414,48,4,31,11],
  [414,41,2,5,25],
  [415,31,41,38,10],
  [415,33,42,7,17],
  [415,37,18,40,8],
  [415,34,16,17,19],
  [415,24,43,26,20],
  [415,12,3,11,12],
  [415,45,13,32,15],
  [415,4,32,-4,18],
  [415,7,48,18,14],
  [415,2,29,18,9],
  [416,48,2,36,14],
  [416,33,31,0,14],
  [416,3,45,17,18],
  [416,18,24,1,14],
  [416,32,7,17,9],
  [416,29,41,12,8],
  [416,42,12,10,26],
  [416,16,37,41,-1],
  [416,43,4,17,14],
  [416,13,34,0,18],
  [417,31,29,10,14],
  [417,4,18,19,16],
  [417,37,13,4,10],
  [417,34,3,8,21],
  [417,7,43,25,7],
  [417,41,48,24,0],
  [417,12,33,20,11],
  [417,2,32,28,8],
  [417,24,16,13,15],
  [417,45,42,37,11],
  [418,32,41,18,9],
  [418,48,29,27,0],
  [418,43,2,23,46],
  [418,18,7,-4,44],
  [418,42,34,33,7],
  [418,3,37,4,1],
  [418,33,45,18,33],
  [418,12,31,5,12],
  [418,16,4,22,-2],
  [418,13,24,20,16],
  [419,37,42,40,5],
  [419,41,43,9,40],
  [419,45,12,26,12],
  [419,2,18,36,-14],
  [419,29,32,18,17],
  [419,31,48,15,8],
  [419,34,33,11,36],
  [419,7,16,9,9],
  [419,4,13,5,3],
  [419,24,3,22,23],
  [420,3,45,21,22],
  [420,16,7,16,22],
  [420,29,41,8,19],
  [420,4,12,26,2],
  [420,43,34,5,10],
  [420,18,42,32,7],
  [420,37,32,15,18],
  [420,24,13,18,12],
  [420,48,33,7,15],
  [420,2,31,35,6],
  [421,33,2,10,18],
  [421,42,37,8,10],
  [421,34,18,19,39],
  [421,45,4,21,14],
  [421,29,3,15,8],
  [421,41,31,12,10],
  [421,12,43,-1,7],
  [421,7,24,28,7],
  [421,32,16,19,24],
  [421,13,48,13,19],
  [422,16,42,18,7],
  [422,24,32,4,6],
  [422,37,34,21,21],
  [422,3,41,12,6],
  [422,18,12,35,23],
  [422,48,7,7,23],
  [422,31,33,23,17],
  [422,2,13,28,1],
  [422,4,29,16,11],
  [422,43,45,19,19],
  [423,12,37,8,13],
  [423,32,48,15,29],
  [423,29,43,14,25],
  [423,42,24,16,28],
  [423,7,2,22,1],
  [423,41,33,34,1],
  [423,34,16,12,19],
  [423,3,4,9,-1],
  [423,45,18,4,16],
  [423,13,31,13,15],
  [424,31,7,17,28],
  [424,48,42,17,11],
  [424,33,13,23,0],
  [424,24,34,15,18],
  [424,16,12,8,15],
  [424,37,45,11,11],
  [424,4,41,10,9],
  [424,18,29,5,19],
  [424,2,32,4,9],
  [424,43,3,18,16],
  [425,42,2,4,0],
  [425,29,37,15,10],
  [425,45,16,13,10],
  [425,41,13,21,1],
  [425,32,31,19,17],
  [425,34,48,18,1],
  [425,12,24,18,8],
  [425,3,18,4,16],
  [425,7,33,18,7],
  [425,4,43,16,22],
  [426,43,41,45,11],
  [426,37,3,20,17],
  [426,18,4,8,14],
  [426,31,42,19,4],
  [426,33,32,13,8],
  [426,13,7,5,39],
  [426,16,29,9,20],
  [426,24,45,19,1],
  [426,48,12,13,-1],
  [426,2,34,18,20],
  [427,3,16,-3,20],
  [427,32,13,24,1],
  [427,4,37,16,25],
  [427,41,7,35,29],
  [427,42,33,16,16],
  [427,45,48,2,20],
  [427,34,31,14,12],
  [427,12,2,41,0],
  [427,29,24,24,3],
  [427,43,18,30,2],
  [428,16,4,14,32],
  [428,2,45,14,36],
  [428,7,32,39,20],
  [428,33,34,9,31],
  [428,37,43,9,16],
  [428,13,42,3,21],
  [428,18,41,37,22],
  [428,48,29,19,12],
  [428,31,12,12,18],
  [428,24,3,11,5],
  [429,43,16,18,5],
  [429,12,33,7,12],
  [429,45,31,18,13],
  [429,4,24,24,12],
  [429,29,2,2,6],
  [429,3,48,5,16],
  [429,42,7,18,27],
  [429,41,32,20,6],
  [429,18,37,14,6],
  [429,34,13,17,26],
  [430,48,4,14,18],
  [430,2,3,7,2],
  [430,33,45,27,5],
  [430,7,34,42,26],
  [430,16,18,13,3],
  [430,24,43,12,11],
  [430,37,41,21,5],
  [430,31,29,44,27],
  [430,13,12,16,11],
  [430,32,42,37,10],
  [431,12,7,1,17],
  [431,34,32,13,17],
  [431,41,42,1,17],
  [431,37,16,9,33],
  [431,18,24,21,5],
  [431,43,48,18,19],
  [431,3,31,23,16],
  [431,29,33,10,24],
  [431,4,2,12,4],
  [431,45,13,17,22],
  [432,33,3,6,8],
  [432,48,18,18,24],
  [432,31,4,10,8],
  [432,16,41,7,-6],
  [432,42,34,23,25],
  [432,24,37,10,11],
  [432,2,43,11,28],
  [432,13,29,23,25],
  [432,7,45,27,18],
  [432,32,12,10,27],
  [433,43,31,11,18],
  [433,3,13,-3,-3],
  [433,16,24,12,23],
  [433,12,42,13,-2],
  [433,29,7,12,8],
  [433,45,32,13,17],
  [433,41,34,17,20],
  [433,18,2,11,10],
  [433,37,48,18,27],
  [433,4,33,14,17],
  [434,48,16,15,21],
  [434,31,18,13,6],
  [434,13,4,13,42],
  [434,7,3,30,9],
  [434,32,29,13,34],
  [434,34,12,19,10],
  [434,24,41,17,7],
  [434,42,45,13,11],
  [434,2,37,7,17],
  [434,33,43,37,30],
  [435,16,2,17,15],
  [435,45,34,1,17],
  [435,29,42,26,14],
  [435,41,12,26,20],
  [435,4,7,31,35],
  [435,18,33,-6,20],
  [435,24,48,26,24],
  [435,3,32,5,19],
  [435,43,13,19,26],
  [435,37,31,26,1],
  [436,32,4,-1,28],
  [436,2,24,8,47],
  [436,31,16,13,-1],
  [436,48,41,20,5],
  [436,7,43,7,19],
  [436,34,29,24,20],
  [436,12,45,9,13],
  [436,33,37,27,22],
  [436,13,18,3,15],
  [436,42,3,17,26],
  [437,37,13,22,26],
  [437,24,31,10,2],
  [437,16,33,7,15],
  [437,3,34,1,24],
  [437,41,45,21,37],
  [437,48,2,11,17],
  [437,4,42,13,24],
  [437,29,12,25,20],
  [437,43,32,31,35],
  [437,18,7,14,20],
  [438,12,3,20,22],
  [438,7,37,16,1],
  [438,2,41,41,7],
  [438,31,48,42,33],
  [438,33,24,24,22],
  [438,13,16,24,18],
  [438,32,18,12,18],
  [438,42,43,6,13],
  [438,34,4,13,6],
  [438,45,29,24,21],
  [439,42,18,24,2],
  [439,34,43,32,20],
  [439,45,3,9,10],
  [439,32,37,3,17],
  [439,7,16,20,13],
  [439,31,2,14,15],
  [439,33,48,24,20],
  [439,13,24,8,27],
  [439,41,29,17,35],
  [439,12,4,14,9],
  [440,43,12,17,23],
  [440,3,29,4,22],
  [440,16,32,9,17],
  [440,48,13,33,0],
  [440,31,41,16,19],
  [440,4,45,4,19],
  [440,18,34,-10,20],
  [440,24,7,20,27],
  [440,2,33,8,10],
  [440,37,42,17,13],
  [441,45,43,28,20],
  [441,29,4,28,11],
  [441,32,24,9,19],
  [441,33,31,28,18],
  [441,12,18,24,27],
  [441,34,37,30,8],
  [441,42,16,34,28],
  [441,7,48,25,11],
  [441,41,3,6,14],
  [441,13,2,5,-4],
  [442,16,34,20,16],
  [442,33,41,22,9],
  [442,48,32,33,21],
  [442,37,12,5,45],
  [442,24,42,23,6],
  [442,18,45,5,-6],
  [442,4,3,7,7],
  [442,2,7,16,12],
  [442,31,13,20,5],
  [442,43,29,26,5],
  [443,3,43,3,20],
  [443,41,4,16,12],
  [443,32,2,14,18],
  [443,45,37,20,39],
  [443,34,24,41,16],
  [443,42,48,30,17],
  [443,13,33,22,26],
  [443,12,16,22,7],
  [443,7,31,15,16],
  [443,29,18,12,7],
  [444,33,7,21,30],
  [444,31,32,5,11],
  [444,2,42,0,10],
  [444,13,41,17,14],
  [444,48,34,14,23],
  [444,24,12,17,27],
  [444,16,45,20,2],
  [444,18,3,-2,11],
  [444,37,29,29,33],
  [444,43,4,12,15],
  [445,45,24,27,9],
  [445,29,16,7,13],
  [445,7,13,13,11],
  [445,4,18,13,7],
  [445,42,31,22,2],
  [445,32,33,18,21],
  [445,34,2,28,45],
  [445,41,43,4,15],
  [445,3,37,-9,3],
  [445,12,48,32,27],
  [446,31,34,20,2],
  [446,7,41,1,12],
  [446,13,32,11,7],
  [446,33,42,25,1],
  [446,48,45,9,39],
  [446,2,12,11,20],
  [446,24,29,16,18],
  [446,16,3,12,-5],
  [446,37,4,11,24],
  [446,18,43,9,14],
  [447,34,33,22,10],
  [447,43,37,17,26],
  [447,45,2,4,20],
  [447,4,16,26,17],
  [447,41,18,9,15],
  [447,12,31,14,15],
  [447,42,13,-3,3],
  [447,29,48,25,8],
  [447,3,24,7,11],
  [447,32,7,9,6],
  [448,7,42,10,-5],
  [448,16,43,11,12],
  [448,24,4,27,23],
  [448,2,29,32,15],
  [448,31,45,2,17],
  [448,33,12,17,38],
  [448,37,18,4,24],
  [448,48,3,10,15],
  [448,32,41,26,13],
  [448,13,34,18,-4],
  [449,3,2,4,4],
  [449,43,24,21,32],
  [449,34,7,35,3],
  [449,12,13,7,18],
  [449,4,48,34,12],
  [449,42,32,5,8],
  [449,18,16,22,5],
  [449,41,37,14,8],
  [449,29,31,36,8],
  [449,45,33,22,23],
  [450,42,41,22,21],
  [450,24,18,19,15],
  [450,16,37,42,20],
  [450,48,43,18,6],
  [450,31,3,9,6],
  [450,2,4,27,36],
  [450,33,29,23,12],
  [450,7,12,9,12],
  [450,32,34,2,23],
  [450,13,45,22,3],
  [451,12,32,30,18],
  [451,43,2,13,25],
  [451,37,24,29,15],
  [451,18,48,18,29],
  [451,4,31,14,14],
  [451,3,33,7,14],
  [451,34,42,29,13],
  [451,41,16,31,1],
  [451,29,13,2,15],
  [451,45,7,25,10],
  [452,42,12,4,15],
  [452,7,29,7,25],
  [452,34,41,0,18],
  [452,32,45,17,21],
  [452,33,4,21,16],
  [452,31,43,27,30],
  [452,13,3,12,21],
  [452,2,18,9,5],
  [452,24,16,23,20],
  [452,48,37,-1,34],
  [453,3,7,12,-2],
  [453,16,48,14,19],
  [453,45,42,13,13],
  [453,37,2,31,4],
  [453,41,24,35,22],
  [453,18,31,2,5],
  [453,29,32,19,-3],
  [453,43,33,26,25],
  [453,12,34,37,18],
  [453,4,13,3,27],
  [454,42,29,13,14],
  [454,12,41,10,16],
  [454,7,4,41,30],
  [454,33,18,23,1],
  [454,31,37,2,23],
  [454,2,16,17,31],
  [454,34,45,26,34],
  [454,32,3,12,13],
  [454,13,43,11,11],
  [454,48,24,21,29],
  [455,37,33,8,18],
  [455,43,7,29,21],
  [455,16,31,15,15],
  [455,4,32,28,13],
  [455,24,2,3,2],
  [455,3,42,13,21],
  [455,41,48,34,21],
  [455,29,34,21,9],
  [455,45,12,14,11],
  [455,18,13,1,8],
  [456,33,16,18,2],
  [456,7,18,15,19],
  [456,34,3,11,1],
  [456,42,4,10,0],
  [456,31,24,15,6],
  [456,45,41,12,-3],
  [456,13,37,3,11],
  [456,2,48,21,11],
  [456,12,29,26,7],
  [456,32,43,32,32],
  [457,43,42,19,15],
  [457,41,2,27,12],
  [457,24,33,10,11],
  [457,16,13,19,-5],
  [457,4,34,16,7],
  [457,37,7,14,35],
  [457,3,12,-1,11],
  [457,29,45,-1,0],
  [457,18,32,-3,17],
  [457,48,31,35,6]  
]

puts("Seeding d11_matches...")

d11_matches.each do | d11_match_day_id, home_d11_team_id, away_d11_team_id, home_team_points, away_team_points |
    status = 2
    d11_match = D11Match.create(d11_match_day_id: d11_match_day_id,
                                home_d11_team_id: home_d11_team_id,
                                away_d11_team_id: away_d11_team_id,
                                home_team_points: home_team_points,
                                away_team_points: away_team_points,
                                status: status)
    D11TeamMatchSquadStat.create(d11_team_id: home_d11_team_id, d11_match_id: d11_match.id)
    D11TeamMatchSquadStat.create(d11_team_id: away_d11_team_id, d11_match_id: d11_match.id)        
end

puts("Updating d11 team stat summaries...")

[D11League.find(11), D11League.find(12)].each do |d11_league|
  d11_league.season.d11_team_season_squad_stats.each do |d11_team_season_squad_stat|
    d11_team_season_squad_stat.save
  end  
end

D11TeamCareerSquadStat.all.each do |d11_team_career_squad_stat|
  d11_team_career_squad_stat.save
end

puts("Updating team_table_stats...")

[ PremierLeague.find(11), PremierLeague.find(12) ].each do |premier_league|
  match_day = premier_league.match_days.first
  match_day.matches.each do |match|
    TeamTableStat.update_stats_from(match) 
  end
  TeamTableStat.update_rankings_from(match_day)  
end

puts("Updating d11_team_table_stats...")

[ D11League.find(11), D11League.find(12) ].each do |d11_league|
  d11_match_day = d11_league.d11_match_days.first
  d11_match_day.d11_matches.each do |d11_match|
    D11TeamTableStat.update_stats_from(d11_match) 
  end
  D11TeamTableStat.update_rankings_from(d11_match_day)  
end
