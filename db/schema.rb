# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180817165956) do

  create_table "cards", force: true do |t|
    t.integer  "match_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "time"
    t.integer  "added_time"
    t.integer  "card_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "iso"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "d11_leagues", force: true do |t|
    t.integer  "season_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "d11_match_days", force: true do |t|
    t.integer  "d11_league_id"
    t.date     "date"
    t.integer  "match_day_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "match_day_id"
  end

  create_table "d11_matches", force: true do |t|
    t.integer  "home_d11_team_id"
    t.integer  "away_d11_team_id"
    t.integer  "d11_match_day_id"
    t.integer  "home_team_goals"
    t.integer  "away_team_goals"
    t.integer  "home_team_points"
    t.integer  "away_team_points"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "elapsed"
    t.integer  "previous_home_team_goals"
    t.integer  "previous_away_team_goals"
    t.integer  "previous_home_team_points"
    t.integer  "previous_away_team_points"
  end

  create_table "d11_team_career_squad_stats", force: true do |t|
    t.integer  "d11_team_id"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "clean_sheets"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "man_of_the_match"
    t.integer  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.integer  "games_started"
    t.integer  "games_substitute"
    t.integer  "games_did_not_participate"
    t.integer  "substitutions_on"
    t.integer  "substitutions_off"
    t.integer  "minutes_played"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_goals"
    t.integer  "points_per_appearance"
  end

  create_table "d11_team_match_squad_stats", force: true do |t|
    t.integer  "d11_team_id"
    t.integer  "d11_match_id"
    t.integer  "team_goals"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "clean_sheets"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "man_of_the_match"
    t.integer  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.integer  "games_started"
    t.integer  "games_substitute"
    t.integer  "games_did_not_participate"
    t.integer  "substitutions_on"
    t.integer  "substitutions_off"
    t.integer  "minutes_played"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points_per_appearance"
  end

  create_table "d11_team_registrations", force: true do |t|
    t.integer  "season_id"
    t.integer  "d11_team_id"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "d11_team_season_squad_stats", force: true do |t|
    t.integer  "d11_team_id"
    t.integer  "season_id"
    t.integer  "team_goals"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "clean_sheets"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "man_of_the_match"
    t.integer  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.integer  "games_started"
    t.integer  "games_substitute"
    t.integer  "games_did_not_participate"
    t.integer  "substitutions_on"
    t.integer  "substitutions_off"
    t.integer  "minutes_played"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points_per_appearance"
  end

  create_table "d11_team_table_stats", force: true do |t|
    t.integer  "d11_team_id"
    t.integer  "d11_league_id"
    t.integer  "d11_match_day_id"
    t.integer  "matches_played"
    t.integer  "matches_won"
    t.integer  "matches_drawn"
    t.integer  "matches_lost"
    t.integer  "goals_for"
    t.integer  "goals_against"
    t.integer  "goal_difference"
    t.integer  "points"
    t.integer  "ranking"
    t.integer  "home_matches_played"
    t.integer  "home_matches_won"
    t.integer  "home_matches_drawn"
    t.integer  "home_matches_lost"
    t.integer  "home_goals_for"
    t.integer  "home_goals_against"
    t.integer  "home_goal_difference"
    t.integer  "home_points"
    t.integer  "home_ranking"
    t.integer  "away_matches_played"
    t.integer  "away_matches_won"
    t.integer  "away_matches_drawn"
    t.integer  "away_matches_lost"
    t.integer  "away_goals_for"
    t.integer  "away_goals_against"
    t.integer  "away_goal_difference"
    t.integer  "away_points"
    t.integer  "away_ranking"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form_points"
    t.integer  "previous_ranking"
  end

  create_table "d11_teams", force: true do |t|
    t.integer  "owner_id"
    t.integer  "co_owner_id"
    t.string   "name"
    t.string   "code"
    t.string   "club_crest_file_name"
    t.string   "club_crest_content_type"
    t.integer  "club_crest_file_size"
    t.datetime "club_crest_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "dummy"
  end

  create_table "goals", force: true do |t|
    t.integer  "match_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "time"
    t.integer  "added_time"
    t.boolean  "penalty"
    t.boolean  "own_goal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_days", force: true do |t|
    t.integer  "premier_league_id"
    t.date     "date"
    t.integer  "match_day_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
  end

  create_table "matches", force: true do |t|
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "match_day_id"
    t.integer  "stadium_id"
    t.integer  "home_team_goals"
    t.integer  "away_team_goals"
    t.datetime "datetime"
    t.string   "elapsed"
    t.integer  "status"
    t.integer  "whoscored_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "previous_home_team_goals"
    t.integer  "previous_away_team_goals"
  end

  create_table "player_career_stats", force: true do |t|
    t.integer  "player_id"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "clean_sheets"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "man_of_the_match"
    t.integer  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.integer  "games_started"
    t.integer  "games_substitute"
    t.integer  "games_did_not_participate"
    t.integer  "substitutions_on"
    t.integer  "substitutions_off"
    t.integer  "minutes_played"
    t.integer  "ranking"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points_per_appearance"
    t.integer  "seasons"
    t.integer  "points_per_season"
  end

  create_table "player_match_stats", force: true do |t|
    t.integer  "player_id"
    t.integer  "match_id"
    t.integer  "team_id"
    t.integer  "d11_team_id"
    t.integer  "position_id"
    t.string   "played_position"
    t.integer  "lineup"
    t.integer  "substitution_on_time"
    t.integer  "substitution_off_time"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "yellow_card_time"
    t.integer  "red_card_time"
    t.boolean  "man_of_the_match"
    t.boolean  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "player_match_stats", ["d11_team_id"], name: "index_player_match_stats_on_d11_team_id"
  add_index "player_match_stats", ["match_id"], name: "index_player_match_stats_on_match_id"
  add_index "player_match_stats", ["player_id"], name: "index_player_match_stats_on_player_id"
  add_index "player_match_stats", ["position_id"], name: "index_player_match_stats_on_position_id"
  add_index "player_match_stats", ["team_id"], name: "index_player_match_stats_on_team_id"

  create_table "player_season_infos", force: true do |t|
    t.integer  "player_id"
    t.integer  "season_id"
    t.integer  "team_id"
    t.integer  "d11_team_id"
    t.integer  "position_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_season_stats", force: true do |t|
    t.integer  "player_id"
    t.integer  "season_id"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "clean_sheets"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "man_of_the_match"
    t.integer  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.integer  "games_started"
    t.integer  "games_substitute"
    t.integer  "games_did_not_participate"
    t.integer  "substitutions_on"
    t.integer  "substitutions_off"
    t.integer  "minutes_played"
    t.integer  "ranking"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form_points"
    t.integer  "points_per_appearance"
  end

  create_table "players", force: true do |t|
    t.integer  "country_id"
    t.integer  "whoscored_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.date     "date_of_birth"
    t.integer  "height"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "player_photo_file_name"
    t.string   "player_photo_content_type"
    t.integer  "player_photo_file_size"
    t.datetime "player_photo_updated_at"
    t.string   "parameterized_name"
  end

  create_table "positions", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "defender"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "premier_leagues", force: true do |t|
    t.integer  "season_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.string   "name"
    t.integer  "status"
    t.date     "date"
    t.boolean  "legacy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "stadia", force: true do |t|
    t.string   "name"
    t.string   "city"
    t.integer  "capacity"
    t.integer  "opened"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "substitutions", force: true do |t|
    t.integer  "match_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "player_in_id"
    t.integer  "time"
    t.integer  "added_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_career_squad_stats", force: true do |t|
    t.integer  "team_id"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "clean_sheets"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "man_of_the_match"
    t.integer  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.integer  "games_started"
    t.integer  "games_substitute"
    t.integer  "games_did_not_participate"
    t.integer  "substitutions_on"
    t.integer  "substitutions_off"
    t.integer  "minutes_played"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points_per_appearance"
    t.integer  "team_goals"
  end

  create_table "team_match_squad_stats", force: true do |t|
    t.integer  "team_id"
    t.integer  "match_id"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "clean_sheets"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "man_of_the_match"
    t.integer  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.integer  "games_started"
    t.integer  "games_substitute"
    t.integer  "games_did_not_participate"
    t.integer  "substitutions_on"
    t.integer  "substitutions_off"
    t.integer  "minutes_played"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points_per_appearance"
    t.integer  "team_goals"
  end

  create_table "team_registrations", force: true do |t|
    t.integer  "season_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_season_squad_stats", force: true do |t|
    t.integer  "team_id"
    t.integer  "season_id"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "clean_sheets"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "man_of_the_match"
    t.integer  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.integer  "games_started"
    t.integer  "games_substitute"
    t.integer  "games_did_not_participate"
    t.integer  "substitutions_on"
    t.integer  "substitutions_off"
    t.integer  "minutes_played"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points_per_appearance"
    t.integer  "team_goals"
  end

  create_table "team_table_stats", force: true do |t|
    t.integer  "team_id"
    t.integer  "premier_league_id"
    t.integer  "match_day_id"
    t.integer  "matches_played"
    t.integer  "matches_won"
    t.integer  "matches_drawn"
    t.integer  "matches_lost"
    t.integer  "goals_for"
    t.integer  "goals_against"
    t.integer  "goal_difference"
    t.integer  "points"
    t.integer  "ranking"
    t.integer  "home_matches_played"
    t.integer  "home_matches_won"
    t.integer  "home_matches_drawn"
    t.integer  "home_matches_lost"
    t.integer  "home_goals_for"
    t.integer  "home_goals_against"
    t.integer  "home_goal_difference"
    t.integer  "home_points"
    t.integer  "home_ranking"
    t.integer  "away_matches_played"
    t.integer  "away_matches_won"
    t.integer  "away_matches_drawn"
    t.integer  "away_matches_lost"
    t.integer  "away_goals_for"
    t.integer  "away_goals_against"
    t.integer  "away_goal_difference"
    t.integer  "away_points"
    t.integer  "away_ranking"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form_points"
    t.integer  "previous_ranking"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "nickname"
    t.integer  "established"
    t.string   "motto"
    t.integer  "stadium_id"
    t.integer  "whoscored_id"
    t.string   "club_crest_file_name"
    t.string   "club_crest_content_type"
    t.integer  "club_crest_file_size"
    t.datetime "club_crest_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "colour"
    t.boolean  "dummy"
  end

  create_table "transfer_bids", force: true do |t|
    t.integer  "transfer_day_id"
    t.integer  "player_id"
    t.integer  "player_ranking"
    t.integer  "d11_team_id"
    t.integer  "d11_team_ranking"
    t.integer  "fee"
    t.integer  "active_fee"
    t.boolean  "successful"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfer_days", force: true do |t|
    t.integer  "transfer_window_id"
    t.integer  "transfer_day_number"
    t.integer  "status"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfer_listings", force: true do |t|
    t.integer  "transfer_day_id"
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "position_id"
    t.integer  "goals"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "goals_conceded"
    t.integer  "clean_sheets"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "man_of_the_match"
    t.integer  "shared_man_of_the_match"
    t.integer  "rating"
    t.integer  "points"
    t.integer  "games_started"
    t.integer  "games_substitute"
    t.integer  "games_did_not_participate"
    t.integer  "substitutions_on"
    t.integer  "substitutions_off"
    t.integer  "minutes_played"
    t.integer  "ranking"
    t.boolean  "new_player"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "d11_team_id"
    t.integer  "points_per_appearance"
  end

  create_table "transfer_windows", force: true do |t|
    t.integer  "season_id"
    t.integer  "d11_match_day_id"
    t.integer  "transfer_window_number"
    t.integer  "status"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfers", force: true do |t|
    t.integer  "transfer_day_id"
    t.integer  "player_id"
    t.integer  "d11_team_id"
    t.integer  "fee"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "administrator",          default: false
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "authentication_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
