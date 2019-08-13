class TransferListingsController < ApplicationController

  def create
    player = Player.find(params[:player_id])
    player_season_info = player.season_info(Season.current)
    player_season_stat = player.season_stat(Season.current)
    transfer_day = TransferDay.current
    if player_season_info.nil? || player_season_stat.nil? || current_user.nil? || player_season_info.d11_team != current_user.active_d11_team || transfer_day.nil?
      not_found
    else
      d11_team_season_squad_stat = player_season_info.d11_team.d11_team_season_squad_stats.where(season: Season.current).take
      if d11_team_season_squad_stat.remaining_transfers <= 0 then
        not_found
      else
        if !player.transfer_listed?
  	      TransferListing.create(transfer_day: transfer_day, player: player, team: player_season_info.team, d11_team: player_season_info.d11_team, position: player_season_info.position, new_player: false)
  	      flash[:success] = "#{player.name} has been transfer listed. He will be removed from #{player_season_info.d11_team.name} if he's not removed from the transfer list before the transfer window opens."
        else
  	      flash[:danger] = "#{player.name} is already transfer listed."
        end
        redirect_to player_season_info.d11_team
      end
    end
  end

  def destroy
    transfer_listing = TransferListing.find(params[:id])
    if !transfer_listing.transfer_day.pending? || current_user.nil? || transfer_listing.d11_team != current_user.active_d11_team
      not_found
    else
      player = transfer_listing.player
      d11_team = transfer_listing.d11_team
      transfer_listing.destroy
      flash[:success] = "#{player.name} has been removed from the transfer list."
      redirect_to d11_team
    end
  end

  def ajax_params
    params.require(:ajax_params).permit(:transfer_day_id)
  end

  private
    def authorize_administrator
      # Override for create and destroy.
    end

end
