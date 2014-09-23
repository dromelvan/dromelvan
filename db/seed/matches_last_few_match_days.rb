home_team_goals = [
  [ 3699, 2 ],
  [ 3707, 4 ],
  [ 3678, 2 ],
  [ 3677, 2 ],  
  [ 3768, 1 ],
  [ 3767, 3 ],
  [ 3774, 2 ],
  [ 3792, 1 ],
  [ 3786, 2 ],
  [ 3785, 3 ],
  [ 3796, 2 ],
  [ 3747, 4 ],
  [ 3750, 5 ],
  [ 3763, 1 ],
  [ 3780, 4 ],
  [ 3761, 3 ],
  [ 3791, 2 ],
  [ 3798, 1 ],
  [ 3746, 1 ],
  [ 3752, 3 ],
  [ 3788, 3 ],
  [ 3745, 3 ],
  [ 3779, 4 ],
  [ 3789, 4 ],
  [ 3770, 3 ],
  [ 3776, 4 ],
  [ 3753, 1 ],
  [ 3782, 1 ],
  [ 3793, 2 ],
  [ 3772, 3 ],
  [ 3800, 3 ],
  [ 3751, 1 ],
  [ 3754, 1 ],
  [ 3756, 3 ],
  [ 3764, 1 ],
  [ 3758, 1 ],
  [ 3755, 3 ],
  [ 3742, 1 ],
  [ 3769, 2 ],
  [ 3777, 2 ],
  [ 3799, 1 ],
  [ 3795, 2 ],
  [ 3801, 1 ],
  [ 3744, 3 ],
  [ 3783, 3 ],
  [ 3765, 2 ],  
  [ 3781, 1 ]  
]

puts("Seeding last few matches home_team_goals...")

home_team_goals.each do | match_id, goals |
  match = Match.find(match_id)
  match.home_team_goals = goals
  match.save
end

away_team_goals = [
  [ 3678, 2 ],
  [ 3677, 3 ],  
  [ 3768, 2 ],
  [ 3767, 1 ],
  [ 3774, 2 ],
  [ 3792, 2 ],  
  [ 3786, 3 ],
  [ 3785, 3 ],
  [ 3760, 1 ],
  [ 3778, 1 ],
  [ 3747, 1 ],
  [ 3749, 1 ],
  [ 3750, 1 ],
  [ 3763, 1 ],
  [ 3780, 1 ],
  [ 3773, 2 ],
  [ 3761, 3 ],
  [ 3787, 1 ],
  [ 3798, 1 ],
  [ 3797, 4 ],
  [ 3752, 1 ],
  [ 3789, 1 ],
  [ 3790, 1 ],
  [ 3770, 1 ],
  [ 3793, 2 ],
  [ 3771, 1 ],
  [ 3751, 2 ],
  [ 3756, 1 ],
  [ 3764, 2 ],
  [ 3759, 1 ],
  [ 3794, 2 ],
  [ 3755, 2 ],
  [ 3742, 2 ],
  [ 3769, 3 ],
  [ 3775, 2 ],
  [ 3799, 3 ],
  [ 3757, 1 ],
  [ 3748, 4 ],
  [ 3743, 3 ],
  [ 3795, 1 ],
  [ 3801, 2 ],
  [ 3766, 3 ],
  [ 3783, 1 ],
]

puts("Seeding last few matches away_team_goals...")

away_team_goals.each do | match_id, goals |
  match = Match.find(match_id)
  match.away_team_goals = goals
  match.save
end

puts("Seeding last few matches status...")

Match.where("match_day_id >= 376").each do |match|
  match.status = 2
  match.save
end