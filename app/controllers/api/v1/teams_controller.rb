class Api::V1::TeamsController < Api::V1::BaseController
  
  def named
    name = params[:name]
    name = name.gsub('+',' ')
    team = Team.named(name).first
    if team.nil?
      not_found
    else    
      render json: team
    end
  end
  
  def squad
    team = Team.find(params[:id])
    json = TeamSerializer.new(team).as_json
    json[:players] = []
    
    PlayerSeasonInfo.where(season: Season.current, team: team).each do |player_season_info|
      player_hash = { :id => player_season_info.player.id,
                      :name => player_season_info.player.name,
                      :whoscored_id => player_season_info.player.whoscored_id,
                      :team => player_season_info.team.name,
                      :position => player_season_info.position.name,
                      :nationality => player_season_info.player.country.name
                      }
      json[:players] << player_hash
    end
    
    render json: json
  end
  
end