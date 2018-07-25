class Api::V1::TeamsController < Api::V1::BaseController
  
  def lineup
    team = Team.find(params[:id])
    json = TeamSerializer.new(team).as_json
    json[:players] = []
    
    PlayerSeasonInfo.where(season: Season.current, team: team).each do |player_season_info|
      player_hash = { :id => player_season_info.player.id,
                      :name => player_season_info.player.name,
                      :whoscored_id => player_season_info.player.whoscored_id,
                      :team => player_season_info.team.name,
                      :position => player_season_info.position.name
                      }
      json[:players] << player_hash
    end
    
    render json: json
  end
  
end