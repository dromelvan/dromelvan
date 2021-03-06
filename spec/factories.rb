include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com"}
    sequence(:name) { |n| "user#{n}"}
    password "password"
    
    factory :admin do
      administrator true
    end    
  end

  factory :post do
    user
    title "Title"
    content "Content."
  end

  factory :country do
    sequence(:name) { |n| "Country #{n}" }
    sequence(:iso) { |n| "#{('AAA'..'ZZZ').to_a[n]}" }    
  end

  factory :d11_team do    
    sequence(:name) { |n| "Test D11 Team #{n}" }
    sequence(:code) { |n| "#{('AAA'..'ZZZ').to_a[n]}" }
    dummy false
    association :owner, factory: :user
  end

  factory :stadium do
    sequence(:name) { |n| "Test Stadium #{n}" }
    city "Test City"
    capacity 12345
    opened 1901
  end

  factory :player do
    sequence(:first_name)  { |n| "First #{n}" }
    sequence(:last_name)  { |n| "Last #{n}" }
    date_of_birth Date.today - 20.year
    country
    whoscored_id 1
  end

  factory :player_season_info do
    player
    season
    team
    d11_team
    position
    value 0
  end

  factory :team do    
    sequence(:name) { |n| "Test Team #{n}" }
    sequence(:code) { |n| "#{('AAA'..'ZZZ').to_a[n]}" }
    sequence(:nickname) { |n| "Nickname #{n}" }
    established 1900  
    motto "Motto"
    stadium
    whoscored_id 1
    dummy false
  end

  factory :season do
    sequence(:name) do |n|
      start = "#{n}"
      start = "0" * (4 - start.length) + start
      stop = "#{n + 1}"
      stop = "0" * (4 - stop.length) + stop
      "#{start}-#{stop}"
    end
    
    date Date.today
  end

  factory :position do
    sequence(:name) { |n| "Position#{n}" }
    defender false
    sequence(:code) do |n|
      "C#{n}"
    end    
    sequence(:sort_order) do |n|
      n
    end    
  end

  factory :premier_league do
    name "Barclays Premier League"
    season
  end

  factory :match_day do
    premier_league        
    date Date.today
    match_day_number 1
    status 0
  end

  factory :match do
    match_day
    association :home_team, factory: :team
    association :away_team, factory: :team
    home_team_goals 0
    away_team_goals 0
    status 0
    datetime Time.now
    elapsed "N/A"
    stadium
    whoscored_id 1
  end

  factory :player_match_stat do
    player
    match
    team
    d11_team
    position
    played_position "POS"
  end

  factory :player_season_stat do
    player
    season
  end

  factory :player_career_stat do
    player
  end

  factory :d11_league do
    name "Drömelvan"
    season
  end

  factory :d11_match_day do
    d11_league
    match_day
    date Date.today
    match_day_number 1
  end

  factory :d11_match do
    d11_match_day
    association :home_d11_team, factory: :d11_team
    association :away_d11_team, factory: :d11_team    
    home_team_goals 0
    away_team_goals 0
    home_team_points 0
    away_team_points 0    
    status 0    
  end
  
  factory :goal do
    match
    player
    team
    time 30
    added_time 0
    penalty false
    own_goal false
  end

  factory :card do
    match
    player
    team
    time 30
    added_time 0
    card_type 0
  end

  factory :substitution do
    match
    player
    association :player_in, factory: :player
    team
    time 30
    added_time 0
  end

  factory :transfer_window do
    season
    d11_match_day
    transfer_window_number 1
    status 0
    datetime DateTime.now
  end

  factory :transfer_day do
    transfer_window
    transfer_day_number 1
    status 0
    datetime DateTime.now
  end
  
  factory :transfer_listing do
    transfer_day
    player
    team
    d11_team
    position
    ranking 0
    new_player false
  end

  factory :transfer_bid do
    transfer_day
    player
    player_ranking 1
    d11_team
    d11_team_ranking 1
    fee 5
    active_fee 5
    successful false
  end

  factory :transfer do
    transfer_day
    player
    d11_team
    fee 5
  end

  factory :d11_team_table_stat do
    d11_team
    d11_league
    d11_match_day    
  end
  
  factory :team_table_stat do
    team
    premier_league
    match_day    
  end

  factory :team_registration do
    team
    season    
  end
  
  factory :d11_team_registration do
    d11_team
    season
  end

  factory :team_match_squad_stat do
    team
    match
  end

  factory :team_season_squad_stat do
    team
    season
  end

  factory :team_career_squad_stat do
    team
  end

  factory :d11_team_match_squad_stat do
    d11_team
    d11_match
  end

  factory :d11_team_season_squad_stat do
    d11_team
    season
  end

  factory :d11_team_career_squad_stat do
    d11_team
  end

end