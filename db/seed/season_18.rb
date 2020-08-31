
seasons = [
  [ "2020-2021", 0, "2019-09-12" ],
]

puts("Seeding seasons...")

seasons.each do |name, status, date|
  Season.create(name: name, status: status, date: date, legacy: false)
end

d11_leagues = [
  [ "Drömelvan", "2020-2021" ]
]

puts("Seeding d11_leagues...")

d11_leagues.each do |name, season|
  D11League.create(name: name, season: Season.where(name: season).first)
end

premier_leagues = [
  [ "Barclays Premier League", "2020-2021" ]
]

puts("Seeding premier_leagues...")

premier_leagues.each do |name, season|
  PremierLeague.create(name: name, season: Season.where(name: season).first)
end

match_days = [
  [ 1, '2020-09-12', 17 ],
  [ 2, '2020-09-19', 17 ],
  [ 3, '2020-09-26', 17 ],
  [ 4, '2020-10-03', 17 ],
  [ 5, '2020-10-17', 17 ],
  [ 6, '2020-10-24', 17 ],
  [ 7, '2020-10-31', 17 ],
  [ 8, '2020-11-07', 17 ],
  [ 9, '2020-11-21', 17 ],
  [ 10, '2020-11-28', 17 ],
  [ 11, '2020-12-05', 17 ],
  [ 12, '2020-12-12', 17 ],
  [ 13, '2020-12-15', 17 ],
  [ 14, '2020-12-19', 17 ],
  [ 15, '2020-12-26', 17 ],
  [ 16, '2020-12-28', 17 ],
  [ 17, '2021-01-02', 17 ],
  [ 18, '2021-01-12', 17 ],
  [ 19, '2021-01-16', 17 ],
  [ 20, '2021-01-26', 17 ],
  [ 21, '2021-01-30', 17 ],
  [ 22, '2021-02-02', 17 ],
  [ 23, '2021-02-06', 17 ],
  [ 24, '2021-02-13', 17 ],
  [ 25, '2021-02-20', 17 ],
  [ 26, '2021-02-27', 17 ],
  [ 27, '2021-03-06', 17 ],
  [ 28, '2021-03-13', 17 ],
  [ 29, '2021-03-20', 17 ],
  [ 30, '2021-04-03', 17 ],
  [ 31, '2021-04-10', 17 ],
  [ 32, '2021-04-17', 17 ],
  [ 33, '2021-04-24', 17 ],
  [ 34, '2021-05-01', 17 ],
  [ 35, '2021-05-08', 17 ],
  [ 36, '2021-05-11', 17 ],
  [ 37, '2021-05-15', 17 ],
  [ 38, '2021-05-23', 17 ]
]

puts("Seeding match_days...")

match_days.each do |match_day_number, date, premier_league_id|
  MatchDay.create(match_day_number: match_day_number, date: date, premier_league: PremierLeague.find(premier_league_id), status: :pending)
end

d11_match_days = [
  [ 1, 17 ],
  [ 2, 17 ],
  [ 3, 17 ],
  [ 4, 17 ],
  [ 5, 17 ],
  [ 6, 17 ],
  [ 7, 17 ],
  [ 8, 17 ],
  [ 9, 17 ],
  [ 10, 17 ],
  [ 11, 17 ],
  [ 12, 17 ],
  [ 13, 17 ],
  [ 14, 17 ],
  [ 15, 17 ],
  [ 16, 17 ],
  [ 17, 17 ],
  [ 18, 17 ],
  [ 19, 17 ],
  [ 20, 17 ],
  [ 21, 17 ],
  [ 22, 17 ],
  [ 23, 17 ],
  [ 24, 17 ],
  [ 25, 17 ],
  [ 26, 17 ],
  [ 27, 17 ],
  [ 28, 17 ],
  [ 29, 17 ],
  [ 30, 17 ],
  [ 31, 17 ],
  [ 32, 17 ],
  [ 33, 17 ],
  [ 34, 17 ],
  [ 35, 17 ],
  [ 36, 17 ],
  [ 37, 17 ],
  [ 38, 17 ]
]

puts("Seeding d11_match_days...")

d11_match_days.each do |match_day_number, d11_league_id|
  d11_league = D11League.find(d11_league_id)
  match_day = MatchDay.where(premier_league: d11_league.season.premier_league, match_day_number: match_day_number).first
  D11MatchDay.create(match_day_number: match_day_number, date: match_day.date, d11_league: d11_league, match_day: match_day)
end

team_registrations = [
  [ 18, 2 ],
  [ 18, 43 ],
  [ 18, 12 ],
  [ 18, 18 ],
  [ 18, 7 ],
  [ 18, 9 ],
  [ 18, 14 ],
  [ 18, 24 ],
  [ 18, 15 ],
  [ 18, 17 ],
  [ 18, 31 ],
  [ 18, 3 ],
  [ 18, 20 ],
  [ 18, 26 ],
  [ 18, 21 ],
  [ 18, 28 ],
  [ 18, 13 ],
  [ 18, 23 ],
  [ 18, 36 ],
  [ 18, 10 ]
]

puts("Seeding team_registrations and other stuff...")

team_registrations.each do | season_id, team_id |
  TeamRegistration.create(season_id: season_id, team_id: team_id)
  TeamSeasonSquadStat.create(season_id: season_id, team_id: team_id)
end

puts("Seeding team_table_stats...")

[17].each do |premier_league_id|
  premier_league = PremierLeague.find(premier_league_id)
  TeamRegistration.where(season: premier_league.season).pluck(:team_id).each do |team_id|
    premier_league.match_days.each do |match_day|
      TeamTableStat.create(team_id: team_id, premier_league_id: premier_league.id, match_day_id: match_day.id)
    end
  end
end

puts("Updating team_table_stats...")

[ PremierLeague.find(17) ].each do |premier_league|
  match_day = premier_league.match_days.first
  match_day.matches.each do |match|
    TeamTableStat.update_stats_from(match)
  end
  TeamTableStat.update_rankings_from(match_day)
end

matches = [
  [ 1, 170, 13, '2020-09-12 12:30', 1485187 ],
  [ 1, 162, 18, '2020-09-12 15:00', 1485186 ],
  [ 1, 29, 23, '2020-09-12 15:00', 1485191 ],
  [ 1, 184, 32, '2020-09-12 15:00', 1485184 ],
  [ 1, 167, 24, '2020-09-12 15:00', 1485185 ],
  [ 1, 26, 19, '2020-09-12 17:30', 1485188 ],
  [ 1, 175, 14, '2020-09-13 14:00', 1485190 ],
  [ 1, 30, 31, '2020-09-13 16:30', 1485189 ],
  [ 1, 211, 15, '2020-09-14 20:00', 1485192 ],
  [ 1, 163, 161, '2020-09-14 20:00', 1485193 ],
  [ 2, 31, 175, '2020-09-19 12:30', 1485197 ],
  [ 2, 19, 170, '2020-09-19 15:00', 1485198 ],
  [ 2, 14, 184, '2020-09-19 15:00', 1485199 ],
  [ 2, 32, 162, '2020-09-19 17:30', 1485200 ],
  [ 2, 18, 30, '2020-09-20 12:00', 1485202 ],
  [ 2, 23, 211, '2020-09-20 14:00', 1485201 ],
  [ 2, 13, 29, '2020-09-20 14:00', 1485194 ],
  [ 2, 24, 163, '2020-09-20 14:00', 1485195 ],
  [ 2, 15, 26, '2020-09-20 16:30', 1485196 ],
  [ 2, 161, 167, '2020-09-21 20:00', 1485203 ],
  [ 3, 211, 32, '2020-09-26 12:30', 1485204 ],
  [ 3, 184, 18, '2020-09-26 15:00', 1485205 ],
  [ 3, 162, 31, '2020-09-26 15:00', 1485206 ],
  [ 3, 29, 161, '2020-09-26 15:00', 1485213 ],
  [ 3, 30, 23, '2020-09-26 15:00', 1485211 ],
  [ 3, 175, 15, '2020-09-26 17:30', 1485212 ],
  [ 3, 163, 19, '2020-09-27 12:00', 1485210 ],
  [ 3, 170, 24, '2020-09-27 14:00', 1485207 ],
  [ 3, 167, 14, '2020-09-27 16:30', 1485209 ],
  [ 3, 26, 13, '2020-09-28 20:00', 1485208 ],
  [ 4, 13, 163, '2020-10-03 15:00', 1485214 ],
  [ 4, 24, 26, '2020-10-03 15:00', 1485215 ],
  [ 4, 15, 162, '2020-10-03 15:00', 1485216 ],
  [ 4, 31, 211, '2020-10-03 15:00', 1485217 ],
  [ 4, 19, 167, '2020-10-03 15:00', 1485218 ],
  [ 4, 14, 29, '2020-10-03 15:00', 1485219 ],
  [ 4, 32, 30, '2020-10-03 15:00', 1485220 ],
  [ 4, 23, 184, '2020-10-03 15:00', 1485221 ],
  [ 4, 18, 175, '2020-10-03 15:00', 1485222 ],
  [ 4, 161, 170, '2020-10-03 15:00', 1485223 ],
  [ 5, 15, 18, '2020-10-17 15:00', 1485224 ],
  [ 5, 162, 211, '2020-10-17 15:00', 1485225 ],
  [ 5, 31, 26, '2020-10-17 15:00', 1485226 ],
  [ 5, 19, 161, '2020-10-17 15:00', 1485227 ],
  [ 5, 14, 24, '2020-10-17 15:00', 1485228 ],
  [ 5, 167, 13, '2020-10-17 15:00', 1485229 ],
  [ 5, 23, 32, '2020-10-17 15:00', 1485230 ],
  [ 5, 163, 170, '2020-10-17 15:00', 1485231 ],
  [ 5, 30, 29, '2020-10-17 15:00', 1485232 ],
  [ 5, 175, 184, '2020-10-17 15:00', 1485233 ],
  [ 6, 13, 14, '2020-10-24 15:00', 1485234 ],
  [ 6, 24, 19, '2020-10-24 15:00', 1485235 ],
  [ 6, 211, 175, '2020-10-24 15:00', 1485236 ],
  [ 6, 184, 30, '2020-10-24 15:00', 1485237 ],
  [ 6, 170, 162, '2020-10-24 15:00', 1485239 ],
  [ 6, 26, 163, '2020-10-24 15:00', 1485241 ],
  [ 6, 32, 15, '2020-10-24 15:00', 1485243 ],
  [ 6, 18, 31, '2020-10-24 15:00', 1485245 ],
  [ 6, 29, 167, '2020-10-24 15:00', 1485247 ],
  [ 6, 161, 23, '2020-10-24 15:00', 1485249 ],
  [ 7, 24, 18, '2020-10-31 15:00', 1485251 ],
  [ 7, 184, 15, '2020-10-31 15:00', 1485253 ],
  [ 7, 170, 175, '2020-10-31 15:00', 1485255 ],
  [ 7, 19, 14, '2020-10-31 15:00', 1485257 ],
  [ 7, 26, 29, '2020-10-31 15:00', 1485259 ],
  [ 7, 32, 13, '2020-10-31 15:00', 1485261 ],
  [ 7, 23, 31, '2020-10-31 15:00', 1485263 ],
  [ 7, 163, 167, '2020-10-31 15:00', 1485265 ],
  [ 7, 30, 211, '2020-10-31 15:00', 1485267 ],
  [ 7, 161, 162, '2020-10-31 15:00', 1485269 ],
  [ 8, 13, 24, '2020-11-07 15:00', 1485271 ],
  [ 8, 211, 184, '2020-11-07 15:00', 1485273 ],
  [ 8, 15, 163, '2020-11-07 15:00', 1485275 ],
  [ 8, 162, 19, '2020-11-07 15:00', 1485277 ],
  [ 8, 31, 32, '2020-11-07 15:00', 1485279 ],
  [ 8, 14, 161, '2020-11-07 15:00', 1485281 ],
  [ 8, 167, 26, '2020-11-07 15:00', 1485283 ],
  [ 8, 18, 23, '2020-11-07 15:00', 1485285 ],
  [ 8, 175, 30, '2020-11-07 15:00', 1485287 ],
  [ 8, 29, 170, '2020-11-07 15:00', 1485289 ],
  [ 9, 24, 211, '2020-11-21 15:00', 1485291 ],
  [ 9, 184, 162, '2020-11-21 15:00', 1485293 ],
  [ 9, 170, 31, '2020-11-21 15:00', 1485295 ],
  [ 9, 19, 13, '2020-11-21 15:00', 1485297 ],
  [ 9, 26, 14, '2020-11-21 15:00', 1485299 ],
  [ 9, 32, 175, '2020-11-21 15:00', 1485301 ],
  [ 9, 23, 15, '2020-11-21 15:00', 1485303 ],
  [ 9, 163, 29, '2020-11-21 15:00', 1485305 ],
  [ 9, 30, 167, '2020-11-21 15:00', 1485307 ],
  [ 9, 161, 18, '2020-11-21 15:00', 1485309 ],
  [ 10, 13, 161, '2020-11-28 15:00', 1485311 ],
  [ 10, 29, 24, '2020-11-28 15:00', 1485254 ],
  [ 10, 175, 163, '2020-11-28 15:00', 1485252 ],
  [ 10, 211, 26, '2020-11-28 15:00', 1485238 ],
  [ 10, 15, 30, '2020-11-28 15:00', 1485240 ],
  [ 10, 162, 23, '2020-11-28 15:00', 1485242 ],
  [ 10, 31, 19, '2020-11-28 15:00', 1485244 ],
  [ 10, 14, 170, '2020-11-28 15:00', 1485246 ],
  [ 10, 167, 184, '2020-11-28 15:00', 1485248 ],
  [ 10, 18, 32, '2020-11-28 15:00', 1485250 ],
  [ 11, 24, 23, '2020-12-05 15:00', 1485256 ],
  [ 11, 211, 18, '2020-12-05 15:00', 1485258 ],
  [ 11, 184, 31, '2020-12-05 15:00', 1485260 ],
  [ 11, 15, 19, '2020-12-05 15:00', 1485262 ],
  [ 11, 26, 161, '2020-12-05 15:00', 1485264 ],
  [ 11, 167, 170, '2020-12-05 15:00', 1485266 ],
  [ 11, 163, 14, '2020-12-05 15:00', 1485268 ],
  [ 11, 30, 13, '2020-12-05 15:00', 1485270 ],
  [ 11, 175, 162, '2020-12-05 15:00', 1485272 ],
  [ 11, 29, 32, '2020-12-05 15:00', 1485274 ],
  [ 12, 162, 30, '2020-12-12 15:00', 1485278 ],
  [ 12, 31, 15, '2020-12-12 15:00', 1485280 ],
  [ 12, 170, 26, '2020-12-12 15:00', 1485282 ],
  [ 12, 19, 29, '2020-12-12 15:00', 1485284 ],
  [ 12, 32, 167, '2020-12-12 15:00', 1485288 ],
  [ 12, 23, 175, '2020-12-12 15:00', 1485290 ],
  [ 12, 18, 163, '2020-12-12 15:00', 1485292 ],
  [ 12, 161, 24, '2020-12-12 15:00', 1485294 ],
  [ 12, 14, 211, '2020-12-13 15:00', 1485286 ],
  [ 12, 13, 184, '2020-12-13 15:00', 1485276 ],
  [ 13, 13, 18, '2020-12-15 19:45', 1485296 ],
  [ 13, 24, 184, '2020-12-15 19:45', 1485298 ],
  [ 13, 170, 211, '2020-12-15 19:45', 1485300 ],
  [ 13, 19, 23, '2020-12-15 19:45', 1485302 ],
  [ 13, 14, 31, '2020-12-15 19:45', 1485304 ],
  [ 13, 163, 32, '2020-12-15 19:45', 1485306 ],
  [ 13, 29, 162, '2020-12-15 19:45', 1485308 ],
  [ 13, 161, 15, '2020-12-15 19:45', 1485310 ],
  [ 13, 26, 30, '2020-12-16 20:00', 1485312 ],
  [ 13, 167, 175, '2020-12-16 20:00', 1485313 ],
  [ 14, 211, 163, '2020-12-19 15:00', 1485314 ],
  [ 14, 184, 161, '2020-12-19 15:00', 1485315 ],
  [ 14, 15, 29, '2020-12-19 15:00', 1485316 ],
  [ 14, 162, 26, '2020-12-19 15:00', 1485317 ],
  [ 14, 31, 13, '2020-12-19 15:00', 1485318 ],
  [ 14, 32, 19, '2020-12-19 15:00', 1485319 ],
  [ 14, 23, 170, '2020-12-19 15:00', 1485320 ],
  [ 14, 18, 167, '2020-12-19 15:00', 1485451 ],
  [ 14, 30, 14, '2020-12-19 15:00', 1485453 ],
  [ 14, 175, 24, '2020-12-19 15:00', 1485455 ],
  [ 15, 13, 15, '2020-12-26 15:00', 1485457 ],
  [ 15, 24, 162, '2020-12-26 15:00', 1485459 ],
  [ 15, 170, 18, '2020-12-26 15:00', 1485461 ],
  [ 15, 19, 184, '2020-12-26 15:00', 1485463 ],
  [ 15, 14, 32, '2020-12-26 15:00', 1485444 ],
  [ 15, 26, 175, '2020-12-26 15:00', 1485445 ],
  [ 15, 167, 23, '2020-12-26 15:00', 1485446 ],
  [ 15, 163, 31, '2020-12-26 15:00', 1485447 ],
  [ 15, 29, 211, '2020-12-26 15:00', 1485448 ],
  [ 15, 161, 30, '2020-12-26 15:00', 1485449 ],
  [ 16, 211, 13, '2020-12-28 15:00', 1485450 ],
  [ 16, 15, 24, '2020-12-28 15:00', 1485454 ],
  [ 16, 184, 163, '2020-12-28 15:00', 1485452 ],
  [ 16, 18, 29, '2020-12-28 15:00', 1485464 ],
  [ 16, 30, 170, '2020-12-28 15:00', 1485465 ],
  [ 16, 175, 19, '2020-12-28 15:00', 1485466 ],
  [ 16, 23, 26, '2020-12-28 15:00', 1485462 ],
  [ 16, 32, 161, '2020-12-28 15:00', 1485460 ],
  [ 16, 31, 167, '2020-12-28 15:00', 1485458 ],
  [ 16, 162, 14, '2020-12-28 15:00', 1485456 ],
  [ 17, 31, 29, '2021-01-02 15:00', 1485321 ],
  [ 17, 32, 24, '2021-01-02 15:00', 1485323 ],
  [ 17, 23, 14, '2021-01-02 15:00', 1485326 ],
  [ 17, 18, 26, '2021-01-02 15:00', 1485329 ],
  [ 17, 30, 19, '2021-01-02 15:00', 1485332 ],
  [ 17, 175, 13, '2021-01-02 15:00', 1485335 ],
  [ 17, 211, 161, '2021-01-02 15:00', 1485467 ],
  [ 17, 184, 170, '2021-01-02 15:00', 1485468 ],
  [ 17, 15, 167, '2021-01-02 15:00', 1485469 ],
  [ 17, 162, 163, '2021-01-02 15:00', 1485470 ],
  [ 18, 13, 162, '2021-01-12 19:45', 1485338 ],
  [ 18, 24, 30, '2021-01-12 19:45', 1485341 ],
  [ 18, 170, 32, '2021-01-12 19:45', 1485344 ],
  [ 18, 19, 18, '2021-01-12 19:45', 1485347 ],
  [ 18, 14, 15, '2021-01-12 19:45', 1485350 ],
  [ 18, 163, 23, '2021-01-12 19:45', 1485353 ],
  [ 18, 29, 175, '2021-01-12 19:45', 1485356 ],
  [ 18, 161, 31, '2021-01-12 19:45', 1485359 ],
  [ 18, 26, 184, '2021-01-13 20:00', 1485362 ],
  [ 18, 167, 211, '2021-01-13 20:00', 1485365 ],
  [ 19, 13, 23, '2021-01-16 15:00', 1485368 ],
  [ 19, 24, 31, '2021-01-16 15:00', 1485371 ],
  [ 19, 170, 15, '2021-01-16 15:00', 1485374 ],
  [ 19, 19, 211, '2021-01-16 15:00', 1485377 ],
  [ 19, 14, 18, '2021-01-16 15:00', 1485380 ],
  [ 19, 26, 32, '2021-01-16 15:00', 1485383 ],
  [ 19, 167, 162, '2021-01-16 15:00', 1485386 ],
  [ 19, 163, 30, '2021-01-16 15:00', 1485389 ],
  [ 19, 29, 184, '2021-01-16 15:00', 1485392 ],
  [ 19, 161, 175, '2021-01-16 15:00', 1485395 ],
  [ 20, 211, 170, '2021-01-26 19:45', 1485398 ],
  [ 20, 184, 24, '2021-01-26 19:45', 1485401 ],
  [ 20, 31, 14, '2021-01-26 19:45', 1485404 ],
  [ 20, 32, 163, '2021-01-26 20:00', 1485407 ],
  [ 20, 175, 167, '2021-01-26 20:00', 1485410 ],
  [ 20, 15, 161, '2021-01-27 19:45', 1485413 ],
  [ 20, 23, 19, '2021-01-27 19:45', 1485416 ],
  [ 20, 18, 13, '2021-01-27 19:45', 1485419 ],
  [ 20, 30, 26, '2021-01-27 19:45', 1485422 ],
  [ 20, 162, 29, '2021-01-27 20:00', 1485425 ],
  [ 21, 13, 32, '2021-01-30 15:00', 1485428 ],
  [ 21, 211, 30, '2021-01-30 15:00', 1485431 ],
  [ 21, 15, 184, '2021-01-30 15:00', 1485434 ],
  [ 21, 162, 161, '2021-01-30 15:00', 1485437 ],
  [ 21, 29, 26, '2021-01-30 15:00', 1485336 ],
  [ 21, 175, 170, '2021-01-30 15:00', 1485333 ],
  [ 21, 18, 24, '2021-01-30 15:00', 1485330 ],
  [ 21, 167, 163, '2021-01-30 15:00', 1485327 ],
  [ 21, 14, 19, '2021-01-30 15:00', 1485324 ],
  [ 21, 31, 23, '2021-01-30 15:00', 1485322 ],
  [ 22, 24, 29, '2021-02-02 19:45', 1485339 ],
  [ 22, 184, 167, '2021-02-02 19:45', 1485342 ],
  [ 22, 170, 14, '2021-02-02 19:45', 1485345 ],
  [ 22, 19, 31, '2021-02-02 19:45', 1485348 ],
  [ 22, 163, 175, '2021-02-02 19:45', 1485351 ],
  [ 22, 161, 13, '2021-02-02 19:45', 1485354 ],
  [ 22, 32, 18, '2021-02-02 20:00', 1485357 ],
  [ 22, 23, 162, '2021-02-03 19:45', 1485360 ],
  [ 22, 30, 15, '2021-02-03 19:45', 1485363 ],
  [ 22, 26, 211, '2021-02-03 20:00', 1485366 ],
  [ 23, 24, 13, '2021-02-06 15:00', 1485369 ],
  [ 23, 184, 211, '2021-02-06 15:00', 1485372 ],
  [ 23, 170, 29, '2021-02-06 15:00', 1485375 ],
  [ 23, 19, 162, '2021-02-06 15:00', 1485378 ],
  [ 23, 26, 167, '2021-02-06 15:00', 1485381 ],
  [ 23, 32, 31, '2021-02-06 15:00', 1485384 ],
  [ 23, 23, 18, '2021-02-06 15:00', 1485387 ],
  [ 23, 163, 15, '2021-02-06 15:00', 1485390 ],
  [ 23, 30, 175, '2021-02-06 15:00', 1485393 ],
  [ 23, 161, 14, '2021-02-06 15:00', 1485396 ],
  [ 24, 13, 19, '2021-02-13 15:00', 1485399 ],
  [ 24, 211, 24, '2021-02-13 15:00', 1485402 ],
  [ 24, 15, 23, '2021-02-13 15:00', 1485405 ],
  [ 24, 162, 184, '2021-02-13 15:00', 1485408 ],
  [ 24, 31, 170, '2021-02-13 15:00', 1485411 ],
  [ 24, 14, 26, '2021-02-13 15:00', 1485414 ],
  [ 24, 167, 30, '2021-02-13 15:00', 1485417 ],
  [ 24, 18, 161, '2021-02-13 15:00', 1485420 ],
  [ 24, 175, 32, '2021-02-13 15:00', 1485423 ],
  [ 24, 29, 163, '2021-02-13 15:00', 1485426 ],
  [ 25, 13, 167, '2021-02-20 15:00', 1485429 ],
  [ 25, 24, 14, '2021-02-20 15:00', 1485432 ],
  [ 25, 211, 162, '2021-02-20 15:00', 1485435 ],
  [ 25, 184, 175, '2021-02-20 15:00', 1485438 ],
  [ 25, 170, 163, '2021-02-20 15:00', 1485440 ],
  [ 25, 26, 31, '2021-02-20 15:00', 1485442 ],
  [ 25, 32, 23, '2021-02-20 15:00', 1485325 ],
  [ 25, 18, 15, '2021-02-20 15:00', 1485328 ],
  [ 25, 29, 30, '2021-02-20 15:00', 1485331 ],
  [ 25, 161, 19, '2021-02-20 15:00', 1485334 ],
  [ 26, 15, 32, '2021-02-27 15:00', 1485337 ],
  [ 26, 31, 18, '2021-02-27 15:00', 1485343 ],
  [ 26, 162, 170, '2021-02-27 15:00', 1485340 ],
  [ 26, 23, 161, '2021-02-27 15:00', 1485355 ],
  [ 26, 167, 29, '2021-02-27 15:00', 1485352 ],
  [ 26, 14, 13, '2021-02-27 15:00', 1485349 ],
  [ 26, 19, 24, '2021-02-27 15:00', 1485346 ],
  [ 26, 175, 211, '2021-02-27 15:00', 1485364 ],
  [ 26, 30, 184, '2021-02-27 15:00', 1485361 ],
  [ 26, 163, 26, '2021-02-27 15:00', 1485358 ],
  [ 27, 24, 161, '2021-03-06 15:00', 1485367 ],
  [ 27, 211, 14, '2021-03-06 15:00', 1485370 ],
  [ 27, 184, 13, '2021-03-06 15:00', 1485373 ],
  [ 27, 15, 31, '2021-03-06 15:00', 1485376 ],
  [ 27, 26, 170, '2021-03-06 15:00', 1485379 ],
  [ 27, 167, 32, '2021-03-06 15:00', 1485382 ],
  [ 27, 163, 18, '2021-03-06 15:00', 1485385 ],
  [ 27, 30, 162, '2021-03-06 15:00', 1485388 ],
  [ 27, 175, 23, '2021-03-06 15:00', 1485391 ],
  [ 27, 29, 19, '2021-03-06 15:00', 1485394 ],
  [ 28, 13, 30, '2021-03-13 15:00', 1485397 ],
  [ 28, 162, 175, '2021-03-13 15:00', 1485400 ],
  [ 28, 31, 184, '2021-03-13 15:00', 1485403 ],
  [ 28, 170, 167, '2021-03-13 15:00', 1485406 ],
  [ 28, 19, 15, '2021-03-13 15:00', 1485409 ],
  [ 28, 14, 163, '2021-03-13 15:00', 1485412 ],
  [ 28, 32, 29, '2021-03-13 15:00', 1485415 ],
  [ 28, 23, 24, '2021-03-13 15:00', 1485418 ],
  [ 28, 18, 211, '2021-03-13 15:00', 1485421 ],
  [ 28, 161, 26, '2021-03-13 15:00', 1485424 ],
  [ 29, 211, 23, '2021-03-20 15:00', 1485427 ],
  [ 29, 184, 14, '2021-03-20 15:00', 1485430 ],
  [ 29, 162, 32, '2021-03-20 15:00', 1485433 ],
  [ 29, 170, 19, '2021-03-20 15:00', 1485436 ],
  [ 29, 26, 15, '2021-03-20 15:00', 1485439 ],
  [ 29, 167, 161, '2021-03-20 15:00', 1485441 ],
  [ 29, 163, 24, '2021-03-20 15:00', 1485443 ],
  [ 29, 30, 18, '2021-03-20 15:00', 1485472 ],
  [ 29, 175, 31, '2021-03-20 15:00', 1485474 ],
  [ 29, 29, 13, '2021-03-20 15:00', 1485476 ],
  [ 30, 13, 26, '2021-04-03 15:00', 1485478 ],
  [ 30, 24, 170, '2021-04-03 15:00', 1485480 ],
  [ 30, 15, 175, '2021-04-03 15:00', 1485482 ],
  [ 30, 31, 162, '2021-04-03 15:00', 1485484 ],
  [ 30, 19, 163, '2021-04-03 15:00', 1485486 ],
  [ 30, 14, 167, '2021-04-03 15:00', 1485488 ],
  [ 30, 32, 211, '2021-04-03 15:00', 1485490 ],
  [ 30, 23, 30, '2021-04-03 15:00', 1485492 ],
  [ 30, 18, 184, '2021-04-03 15:00', 1485494 ],
  [ 30, 161, 29, '2021-04-03 15:00', 1485496 ],
  [ 31, 211, 31, '2021-04-10 15:00', 1485498 ],
  [ 31, 184, 23, '2021-04-10 15:00', 1485500 ],
  [ 31, 162, 15, '2021-04-10 15:00', 1485502 ],
  [ 31, 170, 161, '2021-04-10 15:00', 1485504 ],
  [ 31, 26, 24, '2021-04-10 15:00', 1485506 ],
  [ 31, 167, 19, '2021-04-10 15:00', 1485508 ],
  [ 31, 163, 13, '2021-04-10 15:00', 1485510 ],
  [ 31, 30, 32, '2021-04-10 15:00', 1485512 ],
  [ 31, 175, 18, '2021-04-10 15:00', 1485514 ],
  [ 31, 29, 14, '2021-04-10 15:00', 1485516 ],
  [ 32, 13, 170, '2021-04-17 15:00', 1485518 ],
  [ 32, 24, 167, '2021-04-17 15:00', 1485520 ],
  [ 32, 15, 211, '2021-04-17 15:00', 1485522 ],
  [ 32, 31, 30, '2021-04-17 15:00', 1485524 ],
  [ 32, 19, 26, '2021-04-17 15:00', 1485526 ],
  [ 32, 14, 175, '2021-04-17 15:00', 1485528 ],
  [ 32, 32, 184, '2021-04-17 15:00', 1485530 ],
  [ 32, 23, 29, '2021-04-17 15:00', 1485532 ],
  [ 32, 18, 162, '2021-04-17 15:00', 1485534 ],
  [ 32, 161, 163, '2021-04-17 15:00', 1485536 ],
  [ 33, 13, 31, '2021-04-24 15:00', 1485538 ],
  [ 33, 24, 175, '2021-04-24 15:00', 1485540 ],
  [ 33, 170, 30, '2021-04-24 15:00', 1485542 ],
  [ 33, 19, 32, '2021-04-24 15:00', 1485544 ],
  [ 33, 14, 162, '2021-04-24 15:00', 1485546 ],
  [ 33, 26, 23, '2021-04-24 15:00', 1485548 ],
  [ 33, 167, 18, '2021-04-24 15:00', 1485550 ],
  [ 33, 163, 211, '2021-04-24 15:00', 1485552 ],
  [ 33, 29, 15, '2021-04-24 15:00', 1485554 ],
  [ 33, 161, 184, '2021-04-24 15:00', 1485556 ],
  [ 34, 211, 19, '2021-05-01 15:00', 1485471 ],
  [ 34, 184, 29, '2021-05-01 15:00', 1485473 ],
  [ 34, 15, 170, '2021-05-01 15:00', 1485475 ],
  [ 34, 162, 167, '2021-05-01 15:00', 1485477 ],
  [ 34, 31, 24, '2021-05-01 15:00', 1485479 ],
  [ 34, 32, 26, '2021-05-01 15:00', 1485481 ],
  [ 34, 23, 13, '2021-05-01 15:00', 1485483 ],
  [ 34, 18, 14, '2021-05-01 15:00', 1485485 ],
  [ 34, 30, 163, '2021-05-01 15:00', 1485487 ],
  [ 34, 175, 161, '2021-05-01 15:00', 1485489 ],
  [ 35, 13, 175, '2021-05-08 15:00', 1485491 ],
  [ 35, 24, 32, '2021-05-08 15:00', 1485493 ],
  [ 35, 170, 184, '2021-05-08 15:00', 1485495 ],
  [ 35, 19, 30, '2021-05-08 15:00', 1485497 ],
  [ 35, 14, 23, '2021-05-08 15:00', 1485499 ],
  [ 35, 26, 18, '2021-05-08 15:00', 1485501 ],
  [ 35, 167, 15, '2021-05-08 15:00', 1485503 ],
  [ 35, 163, 162, '2021-05-08 15:00', 1485505 ],
  [ 35, 29, 31, '2021-05-08 15:00', 1485507 ],
  [ 35, 161, 211, '2021-05-08 15:00', 1485509 ],
  [ 36, 211, 29, '2021-05-11 19:45', 1485511 ],
  [ 36, 184, 19, '2021-05-11 19:45', 1485513 ],
  [ 36, 31, 163, '2021-05-11 19:45', 1485515 ],
  [ 36, 32, 14, '2021-05-11 20:00', 1485517 ],
  [ 36, 175, 26, '2021-05-11 20:00', 1485519 ],
  [ 36, 15, 13, '2021-05-12 19:45', 1485521 ],
  [ 36, 23, 167, '2021-05-12 19:45', 1485523 ],
  [ 36, 18, 170, '2021-05-12 19:45', 1485525 ],
  [ 36, 30, 161, '2021-05-12 19:45', 1485527 ],
  [ 36, 162, 24, '2021-05-12 20:00', 1485529 ],
  [ 37, 211, 167, '2021-05-15 15:00', 1485531 ],
  [ 37, 184, 26, '2021-05-15 15:00', 1485533 ],
  [ 37, 15, 14, '2021-05-15 15:00', 1485535 ],
  [ 37, 162, 13, '2021-05-15 15:00', 1485537 ],
  [ 37, 31, 161, '2021-05-15 15:00', 1485539 ],
  [ 37, 32, 170, '2021-05-15 15:00', 1485541 ],
  [ 37, 23, 163, '2021-05-15 15:00', 1485543 ],
  [ 37, 18, 19, '2021-05-15 15:00', 1485545 ],
  [ 37, 30, 24, '2021-05-15 15:00', 1485547 ],
  [ 37, 175, 29, '2021-05-15 15:00', 1485549 ],
  [ 38, 13, 211, '2021-05-23 16:00', 1485551 ],
  [ 38, 24, 15, '2021-05-23 16:00', 1485553 ],
  [ 38, 170, 23, '2021-05-23 16:00', 1485555 ],
  [ 38, 19, 175, '2021-05-23 16:00', 1485557 ],
  [ 38, 14, 30, '2021-05-23 16:00', 1485558 ],
  [ 38, 26, 162, '2021-05-23 16:00', 1485559 ],
  [ 38, 167, 31, '2021-05-23 16:00', 1485560 ],
  [ 38, 163, 184, '2021-05-23 16:00', 1485561 ],
  [ 38, 29, 18, '2021-05-23 16:00', 1485562 ],
  [ 38, 161, 32, '2021-05-23 16:00', 1485563 ],
]

puts("Seeding matches...")

matches.each do | match_day_number, home_team_id, away_team_id, datetime, whoscored_id |
  match_day = MatchDay.where(premier_league_id: 17, match_day_number: match_day_number).first
  home_team = Team.where(whoscored_id: home_team_id).first
  away_team = Team.where(whoscored_id: away_team_id).first

  match = Match.create(home_team_id: home_team.id,
                       away_team_id: away_team.id,
                       home_team_goals: 0,
                       away_team_goals: 0,
                       match_day_id: match_day.id,
                       status: :pending,
                       datetime: datetime,
                       whoscored_id: whoscored_id)
  TeamMatchSquadStat.create(team_id: home_team.id, match_id: match.id)
  TeamMatchSquadStat.create(team_id: away_team.id, match_id: match.id)
end

transfer_windows = [
  [ 18,610,0,"2020-09-10 18:30" ]
]

puts("Seeding transfer windows...")

transfer_windows.each do |season_id, d11_match_day_id, transfer_window_number, datetime|
  TransferWindow.create(season_id: season_id, d11_match_day_id: d11_match_day_id, transfer_window_number: transfer_window_number, datetime: datetime, status: 0)
end

transfer_days = [
  [ 90,1,"2020-09-10 18:30" ]
]

puts("Seeding transfer day...")

transfer_days.each do |transfer_window_id, transfer_day_number, datetime|
  TransferDay.create(transfer_window_id: transfer_window_id, transfer_day_number: transfer_day_number, status: 0, datetime: datetime)
end

puts("Seeding player season infos and stats...")

PlayerSeasonInfo.where(season_id: 17).each do |player_season_info|
  player = player_season_info.player
  team = player_season_info.team
  position = player_season_info.position

  if team.id > 1 then
    PlayerSeasonInfo.create(player: player, season: Season.current, team: team, position: position)
    if !PlayerSeasonStat.where(player: player, season: Season.current).any? then
      PlayerSeasonStat.create(player: player, season: Season.current)
    end
  end
end

d11_teams = [
    [ "Berndtsson", "BER" ],
    [ "Mattsson J", "MAJ" ],
]
puts("Seeding d11_teams...")

d11_teams.each do |name, code|
  D11Team.create(name: name, code: code, owner_id: 1, dummy: false)
end

D11TeamCareerSquadStat.create(d11_team: D11Team.named("Berndtsson").take)
D11TeamCareerSquadStat.create(d11_team: D11Team.named("Mattsson J").take)

d11_team_registrations = [
  [ 18, 2 ],
  [ 18, 4 ],
  [ 18, 7 ],
  [ 18, 12 ],
  [ 18, 13 ],
  [ 18, 16 ],
  [ 18, 24 ],
  [ 18, 29 ],
  [ 18, 31 ],
  [ 18, 32 ],
  [ 18, 33 ],
  [ 18, 34 ],
  [ 18, 35 ],
  [ 18, 51 ],
  [ 18, 38 ],
  [ 18, 41 ],
  [ 18, 52 ],
  [ 18, 43 ],
  [ 18, 48 ],
  [ 18, 50 ],
]

puts("Seeding d11_team_registrations...")

d11_team_registrations.each do | season_id, d11_team_id |
  D11TeamRegistration.create(season_id: season_id, d11_team_id: d11_team_id, approved: true)
  D11TeamSeasonSquadStat.create(season_id: season_id, d11_team_id: d11_team_id )
end

puts("Seeding d11_team_table_stats...")

[17].each do |d11_league_id|
  d11_league = D11League.find(d11_league_id)

  D11TeamRegistration.where(season: d11_league.season).pluck(:d11_team_id).each do |d11_team_id|
    d11_league.d11_match_days.each do |d11_match_day|
      D11TeamTableStat.create(d11_team_id: d11_team_id, d11_league_id: d11_league.id, d11_match_day_id: d11_match_day.id)
    end
  end
end

puts("Updating d11_team_table_stats...")

[ D11League.find(17) ].each do |d11_league|
  d11_match_day = d11_league.d11_match_days.first
  d11_match_day.d11_matches.each do |d11_match|
    D11TeamTableStat.update_stats_from(d11_match)
  end
  D11TeamTableStat.update_rankings_from(d11_match_day)
end

puts("Updating d11_matches...")

d11_matches = [
  [ 610, 38, 31 ],
  [ 610, 32, 48 ],
  [ 610, 7, 4 ],
  [ 610, 51, 12 ],
  [ 610, 29, 34 ],
  [ 610, 33, 50 ],
  [ 610, 2, 35 ],
  [ 610, 52, 13 ],
  [ 610, 43, 24 ],
  [ 610, 16, 41 ],
  [ 611, 31, 41 ],
  [ 611, 24, 16 ],
  [ 611, 13, 43 ],
  [ 611, 35, 52 ],
  [ 611, 50, 2 ],
  [ 611, 34, 33 ],
  [ 611, 12, 29 ],
  [ 611, 4, 51 ],
  [ 611, 48, 7 ],
  [ 611, 38, 32 ],
  [ 612, 32, 31 ],
  [ 612, 7, 38 ],
  [ 612, 51, 48 ],
  [ 612, 29, 4 ],
  [ 612, 33, 12 ],
  [ 612, 2, 34 ],
  [ 612, 52, 50 ],
  [ 612, 43, 35 ],
  [ 612, 16, 13 ],
  [ 612, 41, 24 ],
  [ 613, 31, 24 ],
  [ 613, 13, 41 ],
  [ 613, 35, 16 ],
  [ 613, 50, 43 ],
  [ 613, 34, 52 ],
  [ 613, 12, 2 ],
  [ 613, 4, 33 ],
  [ 613, 48, 29 ],
  [ 613, 38, 51 ],
  [ 613, 32, 7 ],
  [ 614, 7, 31 ],
  [ 614, 51, 32 ],
  [ 614, 29, 38 ],
  [ 614, 33, 48 ],
  [ 614, 2, 4 ],
  [ 614, 52, 12 ],
  [ 614, 43, 34 ],
  [ 614, 16, 50 ],
  [ 614, 41, 35 ],
  [ 614, 24, 13 ],
  [ 615, 31, 13 ],
  [ 615, 35, 24 ],
  [ 615, 50, 41 ],
  [ 615, 34, 16 ],
  [ 615, 12, 43 ],
  [ 615, 4, 52 ],
  [ 615, 48, 2 ],
  [ 615, 38, 33 ],
  [ 615, 32, 29 ],
  [ 615, 7, 51 ],
  [ 616, 51, 31 ],
  [ 616, 29, 7 ],
  [ 616, 33, 32 ],
  [ 616, 2, 38 ],
  [ 616, 52, 48 ],
  [ 616, 43, 4 ],
  [ 616, 16, 12 ],
  [ 616, 41, 34 ],
  [ 616, 24, 50 ],
  [ 616, 13, 35 ],
  [ 617, 31, 35 ],
  [ 617, 50, 13 ],
  [ 617, 34, 24 ],
  [ 617, 12, 41 ],
  [ 617, 4, 16 ],
  [ 617, 48, 43 ],
  [ 617, 38, 52 ],
  [ 617, 32, 2 ],
  [ 617, 7, 33 ],
  [ 617, 51, 29 ],
  [ 618, 29, 31 ],
  [ 618, 33, 51 ],
  [ 618, 2, 7 ],
  [ 618, 52, 32 ],
  [ 618, 43, 38 ],
  [ 618, 16, 48 ],
  [ 618, 41, 4 ],
  [ 618, 24, 12 ],
  [ 618, 13, 34 ],
  [ 618, 35, 50 ],
  [ 619, 31, 50 ],
  [ 619, 34, 35 ],
  [ 619, 12, 13 ],
  [ 619, 4, 24 ],
  [ 619, 48, 41 ],
  [ 619, 38, 16 ],
  [ 619, 32, 43 ],
  [ 619, 7, 52 ],
  [ 619, 51, 2 ],
  [ 619, 29, 33 ],
  [ 620, 33, 31 ],
  [ 620, 2, 29 ],
  [ 620, 52, 51 ],
  [ 620, 43, 7 ],
  [ 620, 16, 32 ],
  [ 620, 41, 38 ],
  [ 620, 24, 48 ],
  [ 620, 13, 4 ],
  [ 620, 35, 12 ],
  [ 620, 50, 34 ],
  [ 621, 31, 34 ],
  [ 621, 12, 50 ],
  [ 621, 4, 35 ],
  [ 621, 48, 13 ],
  [ 621, 38, 24 ],
  [ 621, 32, 41 ],
  [ 621, 7, 16 ],
  [ 621, 51, 43 ],
  [ 621, 29, 52 ],
  [ 621, 33, 2 ],
  [ 622, 2, 31 ],
  [ 622, 52, 33 ],
  [ 622, 43, 29 ],
  [ 622, 16, 51 ],
  [ 622, 41, 7 ],
  [ 622, 24, 32 ],
  [ 622, 13, 38 ],
  [ 622, 35, 48 ],
  [ 622, 50, 4 ],
  [ 622, 34, 12 ],
  [ 623, 31, 12 ],
  [ 623, 4, 34 ],
  [ 623, 48, 50 ],
  [ 623, 38, 35 ],
  [ 623, 32, 13 ],
  [ 623, 7, 24 ],
  [ 623, 51, 41 ],
  [ 623, 29, 16 ],
  [ 623, 33, 43 ],
  [ 623, 2, 52 ],
  [ 624, 52, 31 ],
  [ 624, 43, 2 ],
  [ 624, 16, 33 ],
  [ 624, 41, 29 ],
  [ 624, 24, 51 ],
  [ 624, 13, 7 ],
  [ 624, 35, 32 ],
  [ 624, 50, 38 ],
  [ 624, 34, 48 ],
  [ 624, 12, 4 ],
  [ 625, 31, 4 ],
  [ 625, 48, 12 ],
  [ 625, 38, 34 ],
  [ 625, 32, 50 ],
  [ 625, 7, 35 ],
  [ 625, 51, 13 ],
  [ 625, 29, 24 ],
  [ 625, 33, 41 ],
  [ 625, 2, 16 ],
  [ 625, 52, 43 ],
  [ 626, 43, 31 ],
  [ 626, 16, 52 ],
  [ 626, 41, 2 ],
  [ 626, 24, 33 ],
  [ 626, 13, 29 ],
  [ 626, 35, 51 ],
  [ 626, 50, 7 ],
  [ 626, 34, 32 ],
  [ 626, 12, 38 ],
  [ 626, 4, 48 ],
  [ 627, 31, 48 ],
  [ 627, 38, 4 ],
  [ 627, 32, 12 ],
  [ 627, 7, 34 ],
  [ 627, 51, 50 ],
  [ 627, 29, 35 ],
  [ 627, 33, 13 ],
  [ 627, 2, 24 ],
  [ 627, 52, 41 ],
  [ 627, 43, 16 ],
  [ 628, 16, 31 ],
  [ 628, 41, 43 ],
  [ 628, 24, 52 ],
  [ 628, 13, 2 ],
  [ 628, 35, 33 ],
  [ 628, 50, 29 ],
  [ 628, 34, 51 ],
  [ 628, 12, 7 ],
  [ 628, 4, 32 ],
  [ 628, 48, 38 ],
  [ 629, 31, 38 ],
  [ 629, 48, 32 ],
  [ 629, 4, 7 ],
  [ 629, 12, 51 ],
  [ 629, 34, 29 ],
  [ 629, 50, 33 ],
  [ 629, 35, 2 ],
  [ 629, 13, 52 ],
  [ 629, 24, 43 ],
  [ 629, 41, 16 ],
  [ 630, 41, 31 ],
  [ 630, 16, 24 ],
  [ 630, 43, 13 ],
  [ 630, 52, 35 ],
  [ 630, 2, 50 ],
  [ 630, 33, 34 ],
  [ 630, 29, 12 ],
  [ 630, 51, 4 ],
  [ 630, 7, 48 ],
  [ 630, 32, 38 ],
  [ 631, 31, 32 ],
  [ 631, 38, 7 ],
  [ 631, 48, 51 ],
  [ 631, 4, 29 ],
  [ 631, 12, 33 ],
  [ 631, 34, 2 ],
  [ 631, 50, 52 ],
  [ 631, 35, 43 ],
  [ 631, 13, 16 ],
  [ 631, 24, 41 ],
  [ 632, 24, 31 ],
  [ 632, 41, 13 ],
  [ 632, 16, 35 ],
  [ 632, 43, 50 ],
  [ 632, 52, 34 ],
  [ 632, 2, 12 ],
  [ 632, 33, 4 ],
  [ 632, 29, 48 ],
  [ 632, 51, 38 ],
  [ 632, 7, 32 ],
  [ 633, 31, 7 ],
  [ 633, 32, 51 ],
  [ 633, 38, 29 ],
  [ 633, 48, 33 ],
  [ 633, 4, 2 ],
  [ 633, 12, 52 ],
  [ 633, 34, 43 ],
  [ 633, 50, 16 ],
  [ 633, 35, 41 ],
  [ 633, 13, 24 ],
  [ 634, 13, 31 ],
  [ 634, 24, 35 ],
  [ 634, 41, 50 ],
  [ 634, 16, 34 ],
  [ 634, 43, 12 ],
  [ 634, 52, 4 ],
  [ 634, 2, 48 ],
  [ 634, 33, 38 ],
  [ 634, 29, 32 ],
  [ 634, 51, 7 ],
  [ 635, 31, 51 ],
  [ 635, 7, 29 ],
  [ 635, 32, 33 ],
  [ 635, 38, 2 ],
  [ 635, 48, 52 ],
  [ 635, 4, 43 ],
  [ 635, 12, 16 ],
  [ 635, 34, 41 ],
  [ 635, 50, 24 ],
  [ 635, 35, 13 ],
  [ 636, 35, 31 ],
  [ 636, 13, 50 ],
  [ 636, 24, 34 ],
  [ 636, 41, 12 ],
  [ 636, 16, 4 ],
  [ 636, 43, 48 ],
  [ 636, 52, 38 ],
  [ 636, 2, 32 ],
  [ 636, 33, 7 ],
  [ 636, 29, 51 ],
  [ 637, 31, 29 ],
  [ 637, 51, 33 ],
  [ 637, 7, 2 ],
  [ 637, 32, 52 ],
  [ 637, 38, 43 ],
  [ 637, 48, 16 ],
  [ 637, 4, 41 ],
  [ 637, 12, 24 ],
  [ 637, 34, 13 ],
  [ 637, 50, 35 ],
  [ 638, 50, 31 ],
  [ 638, 35, 34 ],
  [ 638, 13, 12 ],
  [ 638, 24, 4 ],
  [ 638, 41, 48 ],
  [ 638, 16, 38 ],
  [ 638, 43, 32 ],
  [ 638, 52, 7 ],
  [ 638, 2, 51 ],
  [ 638, 33, 29 ],
  [ 639, 31, 33 ],
  [ 639, 29, 2 ],
  [ 639, 51, 52 ],
  [ 639, 7, 43 ],
  [ 639, 32, 16 ],
  [ 639, 38, 41 ],
  [ 639, 48, 24 ],
  [ 639, 4, 13 ],
  [ 639, 12, 35 ],
  [ 639, 34, 50 ],
  [ 640, 34, 31 ],
  [ 640, 50, 12 ],
  [ 640, 35, 4 ],
  [ 640, 13, 48 ],
  [ 640, 24, 38 ],
  [ 640, 41, 32 ],
  [ 640, 16, 7 ],
  [ 640, 43, 51 ],
  [ 640, 52, 29 ],
  [ 640, 2, 33 ],
  [ 641, 31, 2 ],
  [ 641, 33, 52 ],
  [ 641, 29, 43 ],
  [ 641, 51, 16 ],
  [ 641, 7, 41 ],
  [ 641, 32, 24 ],
  [ 641, 38, 13 ],
  [ 641, 48, 35 ],
  [ 641, 4, 50 ],
  [ 641, 12, 34 ],
  [ 642, 12, 31 ],
  [ 642, 34, 4 ],
  [ 642, 50, 48 ],
  [ 642, 35, 38 ],
  [ 642, 13, 32 ],
  [ 642, 24, 7 ],
  [ 642, 41, 51 ],
  [ 642, 16, 29 ],
  [ 642, 43, 33 ],
  [ 642, 52, 2 ],
  [ 643, 31, 52 ],
  [ 643, 2, 43 ],
  [ 643, 33, 16 ],
  [ 643, 29, 41 ],
  [ 643, 51, 24 ],
  [ 643, 7, 13 ],
  [ 643, 32, 35 ],
  [ 643, 38, 50 ],
  [ 643, 48, 34 ],
  [ 643, 4, 12 ],
  [ 644, 4, 31 ],
  [ 644, 12, 48 ],
  [ 644, 34, 38 ],
  [ 644, 50, 32 ],
  [ 644, 35, 7 ],
  [ 644, 13, 51 ],
  [ 644, 24, 29 ],
  [ 644, 41, 33 ],
  [ 644, 16, 2 ],
  [ 644, 43, 52 ],
  [ 645, 31, 43 ],
  [ 645, 52, 16 ],
  [ 645, 2, 41 ],
  [ 645, 33, 24 ],
  [ 645, 29, 13 ],
  [ 645, 51, 35 ],
  [ 645, 7, 50 ],
  [ 645, 32, 34 ],
  [ 645, 38, 12 ],
  [ 645, 48, 4 ],
  [ 646, 48, 31 ],
  [ 646, 4, 38 ],
  [ 646, 12, 32 ],
  [ 646, 34, 7 ],
  [ 646, 50, 51 ],
  [ 646, 35, 29 ],
  [ 646, 13, 33 ],
  [ 646, 24, 2 ],
  [ 646, 41, 52 ],
  [ 646, 16, 43 ],
  [ 647, 31, 16 ],
  [ 647, 43, 41 ],
  [ 647, 52, 24 ],
  [ 647, 2, 13 ],
  [ 647, 33, 35 ],
  [ 647, 29, 50 ],
  [ 647, 51, 34 ],
  [ 647, 7, 12 ],
  [ 647, 32, 4 ],
  [ 647, 38, 48 ],
]
d11_matches.each do | d11_match_day_id, home_d11_team_id, away_d11_team_id |
    status = :pending
    d11_match = D11Match.create(d11_match_day_id: d11_match_day_id, home_d11_team_id: home_d11_team_id, away_d11_team_id: away_d11_team_id, home_team_points: 0, away_team_points: 0, status: status)
    D11TeamMatchSquadStat.create(d11_team_id: home_d11_team_id, d11_match_id: d11_match.id)
    D11TeamMatchSquadStat.create(d11_team_id: away_d11_team_id, d11_match_id: d11_match.id)
end
