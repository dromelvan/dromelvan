class TransfersController < ApplicationController
  layout "modal", only: [ :new ]

  def new
    transfer_day = TransferDay.current
    if transfer_day.nil? || !transfer_day.active?
      not_found
    else      
      @transfer = Transfer.new(fee: 0, transfer_day: transfer_day)      
      if !params[:transfer].nil?
	@transfer.assign_attributes(resource_params)
	if @transfer.player.nil? || !@transfer.player.transfer_listed?
	  not_found
	end
	@transfer.d11_team = D11Team.find(1)
      else
	not_found
      end
    end
  end

  def create
    transfer = Transfer.new(resource_params)
    transfer_day = transfer.transfer_day
    if transfer_day.nil? || !transfer_day.active?
      return not_found
    else            
      transfer = Transfer.new(resource_params)
      transfer.transfer_day = transfer_day
      player = transfer.player
      d11_team = transfer.d11_team
      season = transfer_day.transfer_window.season
      
      if !transfer.d11_team.dummy?               	
	d11_team_table_stat = d11_team.d11_team_table_stats.where(d11_match_day: season.d11_league.current_d11_match_day).take
	d11_team_season_squad_stat = d11_team.d11_team_season_squad_stats.where(season: season).take
        if d11_team_table_stat.nil? || d11_team_season_squad_stat.nil?
          return not_found
        end
        if transfer.fee <= 0
          flash[:danger] = "The transfer fee must be greater than 0.0."
          return redirect_to player
        end
        if transfer.fee > d11_team_season_squad_stat.max_bid
          flash[:danger] = "Transfer fee #{transfer.fee / 10.0} is higher than max bid #{d11_team_season_squad_stat.max_bid / 10.0} for #{d11_team.name}."
          return redirect_to d11_team
        end
        position = player.season_info(season).position        
        if !d11_team_season_squad_stat.position_available(position)
          flash[:danger] = "#{d11_team.name} has no more room for players in position #{position.name.downcase}."
          return redirect_to d11_team
        end                
      end
      
      old_transfer_bid = transfer_day.transfer_bids.where(player: player).first
      if !old_transfer_bid.nil?
        old_transfer_bid.delete
      end
      old_transfer = transfer_day.transfers.where(player: player).first
      if !old_transfer.nil?
        old_transfer.delete
      end
      
      if !transfer.d11_team.dummy?        
        player_season_stat = player.season_stat(season)      
        d11_team_table_stat = d11_team.d11_team_table_stats.where(d11_match_day: season.d11_league.current_d11_match_day).take

        transfer_bid = TransferBid.new
        transfer_bid.transfer_day = transfer_day
        transfer_bid.player = player
        transfer_bid.player_ranking = player_season_stat.ranking
        transfer_bid.d11_team = d11_team
        transfer_bid.d11_team_ranking = d11_team_table_stat.ranking
        transfer_bid.fee = transfer.fee
        transfer_bid.active_fee = transfer.fee
        transfer_bid.successful = true
        transfer_bid.save
        
        transfer.save
      end
      
      player_season_info = player.season_info(season)
      player_season_info.value = transfer.fee
      player_season_info.d11_team = d11_team
      player_season_info.save
      
      if !d11_team.dummy?
        flash[:success] = "Player #{player.name} has been transferred to #{d11_team.name} for a fee of #{transfer.fee / 10.0} million."
        
	d11_team_season_squad_stat = d11_team.d11_team_season_squad_stats.where(season: season).take
	if d11_team_season_squad_stat.max_bid <= 0
	  flash[:info] = "Team #{d11_team.name} has a full squad."
	end
        
        redirect_to d11_team
      else
        flash[:success] = "Player #{player.name} has been removed from the D11 team."
        redirect_to player
      end
    end        
  end
  
  def resource_params
    resource_params ||= params.require(:transfer).permit(:transfer_day_id, :player_id, :d11_team_id, :fee)
    fee = resource_params[:fee]
    if (Float(fee) rescue false) or (Integer(fee) rescue false) then
      resource_params[:fee] = (fee.to_f * 10).to_int.to_s
    end      
    resource_params
  end

end