class Api::V1::MatchDaysController < Api::V1::BaseController

  before_action :authorize_administrator,  only: [:activate]

  def show
    match = MatchDay.find(params[:id])  
    render json: match
  end

  def current
    match_day = PremierLeague.current.current_match_day
    
    if !match_day.nil?      
      render json: match_day
    else
      not_found
    end
  end
  
  def upcoming
    match_day = PremierLeague.current.current_match_day
    upcoming_match_day = match_day.next
    
    if !upcoming_match_day.nil?
      render json: upcoming_match_day
    else
      not_found
    end
  end

  def by_season
    season = Season.find(params[:season_id])
    match_days = season.premier_league.match_days
    render json: match_days
  end

  def activate
    match_day = MatchDay.find(params[:id])
    if match_day.pending?
      match_day.status = :active
      match_day.save
      
      PlayerSeasonInfo.where(season: match_day.premier_league.season).each do |player_season_info|
        match = match_day.matches.by_team(player_season_info.team).take
        PlayerMatchStat.create(player: player_season_info.player, match: match, team: player_season_info.team, d11_team: player_season_info.d11_team, position: player_season_info.position, played_position: player_season_info.position.code)
      end
      
      render json: match_day.reload
    else
      not_found
    end    
  end
  
end