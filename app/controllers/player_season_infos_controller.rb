class PlayerSeasonInfosController < ApplicationController
  layout "modal", only: [ :edit ]
  before_action :authorize_administrator, only: [:new, :create, :edit, :update, :delete, :create_current]

  def edit
    super
    @player = @player_season_info.player
  end
  
  def update
    if !administrator_signed_in?
      not_found
    else
      player_season_info = PlayerSeasonInfo.find(params[:id])
      if player_season_info.update_attributes(resource_params)
        flash[:success] = "Player season information updated."
      else
        flash[:validation_errors] = player_season_info
      end    
      redirect_to player_season_info.player
    end
  end

  def create_current
    player = Player.find(params[:id])
    team = Team.find(1)
    position = Position.find(6)
    player_season_infos = PlayerSeasonInfo.by_player(player)
    if player_season_infos.any?
      team = player_season_infos.first.team
      position = player_season_infos.first.position
    end
    PlayerSeasonInfo.create(player: player, season: Season.current, team: team, position: position)
    if !PlayerSeasonStat.where(player: player, season: Season.current).any? then
      PlayerSeasonStat.create(player: player, season: Season.current)
    end
    flash[:success] = "Successfully created player season info for #{player.name}, season #{Season.current.name}."
    redirect_to player
  end
  
  private
    def resource_params
      @resource_params ||= params.require(:player_season_info).permit(:team_id, :d11_team_id, :value, :position_id)
      value = @resource_params[:value]
      if (Float(value) rescue false) or (Integer(value) rescue false) then
        @resource_params[:value] = (value.to_f * 10).to_int.to_s
      end      
      @resource_params
    end
  
end
