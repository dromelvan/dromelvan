class TransferDaysController < ApplicationController
  include Select, TransferBids, TransferListings, StatusEnum
  
  def pend
    transfer_day = TransferDay.find(status_enum_params[:id])
    flash[:danger] = "The status of a transfer day cannot be changed from any other status to pending."
    redirect_to transfer_day
  end
  
  def activate
    transfer_day = TransferDay.find(status_enum_params[:id])
    update_status(transfer_day, :active)

    transfer_window = transfer_day.transfer_window
    if transfer_window.pending?
      transfer_window.status = :active
      transfer_window.save
    end
    
    PlayerSeasonInfo.joins(:team).joins(:d11_team).where(season: Season.current, teams: { dummy: false}, d11_teams: { dummy: true}).each do |player_season_info|
      transfer_listing = TransferListing.new(transfer_day: transfer_day, player: player_season_info.player, team: player_season_info.team, d11_team: player_season_info.d11_team,
			       position: player_season_info.position, new_player: false)
      player_season_stat = player_season_info.player.season_stat(player_season_info.season)
      transfer_listing.init_from(player_season_stat)
      transfer_listing.save
    end
    
    transfer_day.transfer_listings.joins(:d11_team).where(d11_teams: { dummy: false }).each do |transfer_listing|
      player_season_stat = transfer_listing.player.season_stat(Season.current)
      transfer_listing.init_from(player_season_stat)
      transfer_listing.save
      player_season_info = transfer_listing.player.season_info(Season.current)
      player_season_info.d11_team = D11Team.find(1)
      player_season_info.value = 0
      player_season_info.save
    end    
  end

  def finish
    transfer_day = TransferDay.find(status_enum_params[:id])
    finish_transfer_day = FinishTransferDay.new(transfer_day)
puts("IDD: #{transfer_day.id}")    
    finish_transfer_day.finish
    redirect_to transfer_day
  end
  
end
