class FinishTransferDay
  def initialize(transfer_day)
    @transfer_day = transfer_day
  end
  
  def finish
    if @transfer_day.active?
      # Skip all this if the transfer day is a live auction transfer day.
      if !@transfer_day.transfers.empty?
	@transfer_day.status = :finished
	@transfer_day.save
	@transfer_day.transfer_window.status = :finished
	@transfer_day.transfer_window.save
	return	
      end
      
      TransferDay.transaction do
	season = @transfer_day.transfer_window.season
	
	# Collect all team max bids and available positions in a hash.
	d11_teams = {}
	D11TeamSeasonSquadStat.where(season: season).each do |d11_team_season_squad_stat|
	  d11_teams[d11_team_season_squad_stat.d11_team_id] = { max_bid: d11_team_season_squad_stat.max_bid }
	  positions_available_count = 0
	  Position.all.each do |position|
	    if position.id != 2
	      position_available_count = d11_team_season_squad_stat.position_available_count(position)
	      d11_teams[d11_team_season_squad_stat.d11_team_id][position.id] = position_available_count
	      positions_available_count += position_available_count
	    end
	  end
	  d11_teams[d11_team_season_squad_stat.d11_team_id][:positions_available_count] = positions_available_count
	end
	
	# Deal with all bids for one player in ascending player ranking order.
	@transfer_day.transfer_bids.pluck(:player_ranking).uniq.each do |player_ranking|
	  player_transfer_bids = @transfer_day.transfer_bids.where(player_ranking: player_ranking)	
  
	  # The default scope in TransferBid makes sure the first bid is the bid with the highest active fee and the worst D11 team ranking.
	  # This bid will be the winning bid.
	  first_transfer_bid = player_transfer_bids.first
	  
	  # It might happen that all bids for one player end up as 0, in that case, skip it.
	  if first_transfer_bid.active_fee > 0
	    first_transfer_bid.successful = true
	    
	    # Compare the winning bid to the next highest bid and reduce it to the next highest bid + 0.5 if the winning bid is higher.
	    second_transfer_bid = player_transfer_bids.second	  
	    if !second_transfer_bid.nil?
	      if first_transfer_bid.active_fee > second_transfer_bid.active_fee
		first_transfer_bid.active_fee = second_transfer_bid.active_fee + 5
	      end
	    else
	      first_transfer_bid.active_fee = 5
	    end
	    first_transfer_bid.save
	    
	    Transfer.create(transfer_day: @transfer_day, player: first_transfer_bid.player, d11_team: first_transfer_bid.d11_team, fee: first_transfer_bid.active_fee)
	    
	    # Update player season info.
	    player_season_info = first_transfer_bid.player.season_info(season)
	    player_season_info.d11_team = first_transfer_bid.d11_team
	    player_season_info.value = first_transfer_bid.active_fee
	    player_season_info.save
	    
	    # Reduce the available spots for the position of the player in the winning bid and the total available spots for the team.
	    # Also reduce the max bid for the team since a portion of the budget has been used up.
	    d11_team = first_transfer_bid.d11_team
	    position = first_transfer_bid.player.season_info(season).position	  
	    d11_teams[d11_team.id][position.id] = d11_teams[d11_team.id][position.id] - 1 
	    d11_teams[d11_team.id][:positions_available_count] = d11_teams[d11_team.id][:positions_available_count] - 1
	    if d11_teams[d11_team.id][:positions_available_count] > 0
	      d11_teams[d11_team.id][:max_bid] = d11_teams[d11_team.id][:max_bid] - first_transfer_bid.active_fee + 5
	    else
	      d11_teams[d11_team.id][:max_bid] = 0
	    end
	    
	    # Reduce the active fees for all remaining bids for the team that had the winning bid.
	    @transfer_day.transfer_bids.where(d11_team: first_transfer_bid.d11_team).each do |transfer_bid|
	      if transfer_bid.player_ranking > first_transfer_bid.player_ranking
		player_season_info = transfer_bid.player.season_info(season)
		if d11_teams[d11_team.id][player_season_info.position.id] <= 0
		  # If there's no more room in the position, set the active bid to 0.0.
		  transfer_bid.active_fee = 0
		  transfer_bid.save
		elsif transfer_bid.active_fee > d11_teams[d11_team.id][:max_bid]
		  # If there is more room, reduce the active fee to max bid if the active fee is higher.
		  transfer_bid.active_fee = d11_teams[d11_team.id][:max_bid]
		  transfer_bid.save
		end	      
	      end	    
	    end
	  end
	end
	
	@transfer_day.status = :finished
	@transfer_day.save

        # Insert a new transfer day if all teams aren't full.
        new_transfer_day = false
	d11_teams.keys.each do |d11_team_id|
	  if d11_teams[d11_team_id][:positions_available_count] > 0
	    transfer_day = TransferDay.create(transfer_window: @transfer_day.transfer_window, transfer_day_number: @transfer_day.transfer_day_number + 1, status: :active, datetime: @transfer_day.datetime + 1.day)
	    
	    PlayerSeasonInfo.joins(:team).joins(:d11_team).where(season: season, teams: { dummy: false}, d11_teams: { dummy: true}).each do |player_season_info|
	      transfer_listing = TransferListing.new(transfer_day: transfer_day, player: player_season_info.player, team: player_season_info.team, d11_team: player_season_info.d11_team,
				       position: player_season_info.position, new_player: false)
	      player_season_stat = player_season_info.player.season_stat(player_season_info.season)
	      transfer_listing.init_from(player_season_stat)
	      transfer_listing.save
	    end
	    new_transfer_day = true
	    break
	  end	  
	end
	
	if !new_transfer_day
	  @transfer_day.transfer_window.status = :finished
	  @transfer_day.transfer_window.save	  
	end
      end
    end
  end  
end