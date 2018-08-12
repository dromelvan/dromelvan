class UploadMatchStatsJsonFile < UploadJsonFile
  def initialize(match, update_table_stats)
    @match = match
    @update_table_stats = update_table_stats
  end

  private
    def validate_data(match)
      data_errors = []
      missing_players = []

      # Check that we have the right match.    
      if @match.whoscored_id != match.whoscored_id
        data_errors.concat [ "Invalid match. The selected match has whoscored_id #{@match.whoscored_id} but the uploaded file contains data for match #{match.whoscored_id}." ]        
      end

      # Check that the match has the right teams.
      if @match.home_team.whoscored_id != match.home_team.whoscored_id
        data_errors.concat [ "Invalid team. The match home team has whoscored_id #{@match.home_team.whoscored_id} but the uploaded file contains home team whoscored_id #{match.home_team.whoscored_id}." ]        
      end
      if @match.away_team.whoscored_id != match.away_team.whoscored_id
        data_errors.concat [ "Invalid team. The match away team has whoscored_id #{@match.away_team.whoscored_id} but the uploaded file contains away team whoscored_id #{match.away_team.whoscored_id}." ]        
      end
      season = @match.match_day.premier_league.season
      
      # Check that all the players exist.
      player_match_stats = {}
      match.player_match_stats.each do |player_match_stat|
        player_whoscored_id = player_match_stat.player.whoscored_id
        player_match_stats[player_whoscored_id] = player_match_stat
        player = Player.where(whoscored_id: player_whoscored_id).first
        if player.nil?
          # If there's a player with the same parameterized name in the same team then we're going to
          # change that players whoscored_id when we insert the data so we won't bother marking him as missing.
          player_name = player_match_stat.player.name
          team_whoscored_id = player_match_stat.team.whoscored_id
          position_id = player_match_stat.position
          team_id = (@match.home_team.whoscored_id == team_whoscored_id ? @match.home_team_id : @match.away_team_id)
          if !Player.joins(player_season_infos: :team).where(player_season_infos: { season: season }, teams: {whoscored_id: team_whoscored_id}, parameterized_name: player_name.parameterize).any?
              team_name = player_match_stat.team.name
              missing_players.concat [ { player_whoscored_id: player_whoscored_id, player_name: player_name, team_id: team_id, team_name: team_name, position_id: position_id, alternative_players: Player.named(player_name, :or) } ]
          end          
        end
      end
      
      # The checks below are probably unnecessary as they most likely will never happen but just in case...
      # Check that all match events have players and teams that take part in the match.
      (match.goals | match.cards | match.substitutions).each do |match_event|
        [ match_event.player, match_event.player_in ].each do |player|
          if !player.nil?
            player_whoscored_id = player.whoscored_id
            player_name = player.name
            if player_match_stats[player_whoscored_id].nil?
              data_errors.concat ["Invalid match event. Player #{player_name} (#{player_whoscored_id}) is referenced in a match event but is not listed in any of the team squads."]
            end
          end
        end
        team_whoscored_id = match_event.team.whoscored_id
        team_name = match_event.team.name
        if @match.home_team.whoscored_id != team_whoscored_id && @match.away_team.whoscored_id != team_whoscored_id
          data_errors.concat ["Invalid match event. Team #{team_name} (#{team_whoscored_id}) is referenced in a match event but is not one of the teams playing this match."]
        end
      end

      # Check that own goals and penalties have the right teams and make sense.
      match.goals.each do |goal|
        if goal.own_goal
          player_whoscored_id = goal.player.whoscored_id
          player_match_stat = player_match_stats[player_whoscored_id]
          if !player_match_stat.nil? && player_match_stat.team.whoscored_id == goal.team.whoscored_id
            data_errors.concat ["Invalid own goal. Player #{goal.player.name} (#{player_whoscored_id}) is registered as having scored an own goal for his own team in this match."]
          end
          if goal.penalty
            data_errors.concat ["Invalid own goal. Player #{goal.player.name} (#{player_whoscored_id}) is registered as having scored a penalty own goal."]
          end
        end        
      end
      
      return data_errors, missing_players
    end
    
    def update_data(match)
      data_updates = []
      if match.elapsed == "N/A"
        return data_updates
      end
      
      Match.transaction do
        player_match_stats = {}
        @match.player_match_stats.each do |player_match_stat|
          player_match_stat.reset
          player_match_stats[player_match_stat.player.whoscored_id] = player_match_stat
        end
        @match.goals.delete_all
        @match.cards.delete_all
        @match.substitutions.delete_all
        @match.status = :active

        season = @match.match_day.premier_league.season
        
        match.player_match_stats.each do |player_match_stat_json|
          whoscored_id = player_match_stat_json.player.whoscored_id
          player = Player.where(whoscored_id: whoscored_id).take
          team = Team.where(whoscored_id: player_match_stat_json.team.whoscored_id).take

          # If we can't find a player with a given whoscored_id, find the one with the same name in the same team and change his whoscored_id.
          # If there is no such player then the validation will have failed before we get here.
          if player.nil?            
            player = Player.joins(player_season_infos: :team).where(player_season_infos: { season: season }, teams: {whoscored_id: team.whoscored_id}, parameterized_name: player_match_stat_json.player.name.parameterize).take
            old_whoscored_id = player.whoscored_id
            player.whoscored_id = whoscored_id
            player.save
            data_updates.concat([ "Changed whoscored id for player #{player.name} from #{old_whoscored_id} to #{player.whoscored_id}." ])
            player_match_stats[player.whoscored_id] = player_match_stats[old_whoscored_id]
            player_match_stats.delete(old_whoscored_id)            
          end

          player_season_info = player.season_info(season)
          use_d11_team = true

          # Add or move players who aren't registered for this season or who are registered for another team than
          # the team the match file says the player is playing for in this match.
          if player_season_info.nil?            
            previous_player_season_info = player.player_season_infos.first
            position = (!previous_player_season_info.nil? ? previous_player_season_info.position : Position.find(6))
            player_season_info = PlayerSeasonInfo.create(player: player, season: season, team: team, position: position)
            PlayerSeasonStat.create(player: player, season: season)
            data_updates.concat([ "Added player #{player.name} (#{player.whoscored_id}) to team #{team.name}." ])
          elsif player_season_info.team != team
            old_team = player_season_info.team
            player_season_info.team = team
            player_season_info.save

            # Remove existing player_match_stats for this match day so the player doesn't end up playing two matches for the same D11 team
            # the same match day. NOTE: This means we might have to change things manually after uploading postponed matches to avoid screwing things up.
            PlayerMatchStat.joins(:match).where(matches: { match_day_id: @match.match_day_id }, player_id: player.id).each do |player_match_stat|
              if player_match_stat.match != @match
                if player_match_stat.did_not_participate?                
                  player_match_stat.delete
                  data_updates.concat([ "Deleted match stats for player #{player.name} (D11 Team: #{player_match_stat.d11_team.name}, whoscored_id: #{player.whoscored_id}) from match #{player_match_stat.match.home_team.name} vs #{player_match_stat.match.away_team.name}" ])
                else
                  data_updates.concat([ "Player #{player.name} (D11 Team: #{player_season_info.d11_team.name}, whoscored_id: #{player.whoscored_id}) already participated in match #{player_match_stat.match.home_team.name} vs #{player_match_stat.match.away_team.name} so the stats for this game will not be counted for the D11 owner." ])
                  use_d11_team = false
                end                
              end
            end
            data_updates.concat([ "Moved player #{player.name} (D11 Team: #{player_season_info.d11_team.name}, whoscored_id: #{player.whoscored_id}) from team #{old_team.name} to team #{team.name}." ])
          end

          # Create player_match_stat for players who've been added to the match teams after the match day was activated.
          player_match_stat = player_match_stats[whoscored_id]
          if player_match_stat.nil?
            d11_team = (use_d11_team ? player_season_info.d11_team : D11Team.find(1))
            player_match_stat = PlayerMatchStat.create(match: @match, player: player, team: team, d11_team: d11_team, position: player_season_info.position)
            player_match_stats[whoscored_id] = player_match_stat
          end

          # Update stats.
          player_match_stat.played_position = player_match_stat_json.played_position
          player_match_stat.lineup = player_match_stat_json.lineup
          player_match_stat.substitution_on_time = player_match_stat_json.substitution_on_time
          player_match_stat.substitution_off_time = player_match_stat_json.substitution_off_time
          player_match_stat.goals = player_match_stat_json.goals
          player_match_stat.goal_assists = player_match_stat_json.goal_assists
          player_match_stat.own_goals = player_match_stat_json.own_goals
          player_match_stat.goals_conceded = player_match_stat_json.goals_conceded
          player_match_stat.yellow_card_time = player_match_stat_json.yellow_card_time
          player_match_stat.red_card_time = player_match_stat_json.red_card_time
          player_match_stat.man_of_the_match = player_match_stat_json.man_of_the_match
          player_match_stat.shared_man_of_the_match = player_match_stat_json.shared_man_of_the_match
          player_match_stat.rating = player_match_stat_json.rating
        end
        
        player_match_stats.values.each do |player_match_stat|
          player_match_stat.save
          player = player_match_stat.player
          PlayerSeasonStat.where(player: player, season: season).take.save
          PlayerCareerStat.where(player: player).take.save                    
        end
        
        match.goals.each do |goal|
          player = Player.where(whoscored_id: goal.player.whoscored_id).first
          team = Team.where(whoscored_id: goal.team.whoscored_id).first
          time = goal.time
          penalty = goal.penalty
          own_goal = goal.own_goal
          Goal.create(match: @match, player: player, team: team, time: time, penalty: penalty, own_goal: own_goal)          
        end
        
        match.cards.each do |card|
          player = Player.where(whoscored_id: card.player.whoscored_id).first
          team = Team.where(whoscored_id: card.team.whoscored_id).first
          time = card.time
          card_type = card.card_type
          Card.create(match: @match, player: player, team: team, time: time, card_type: card_type)          
        end
        
        match.substitutions.each do |substitution|
          player_in = Player.where(whoscored_id: substitution.player_in.whoscored_id).first
          player = Player.where(whoscored_id: substitution.player.whoscored_id).first
          team = Team.where(whoscored_id: substitution.team.whoscored_id).first
          time = substitution.time
          Substitution.create(match: @match, player: player, player_in: player_in, team: team, time: time)          
        end

        if match.elapsed == "FT"
          @match.status = :finished
        else
          @match.elapsed = match.elapsed
        end
        @match.save

        PlayerSeasonStat.update_rankings(season)
        PlayerCareerStat.update_rankings                    
                        
        @match.team_match_squad_stats.each do |team_match_squad_stat|
          team_match_squad_stat.save
        end
        
        if @update_table_stats
          TeamTableStat.update_stats_from(@match)
          TeamTableStat.update_rankings_from(@match.match_day)
        end
        
        @match.match_day.d11_match_day.d11_matches.each do |d11_match|
          d11_match.d11_team_match_squad_stats.each do |d11_team_match_squad_stat|
            d11_team_match_squad_stat.save
          end
          d11_match.save
          if @update_table_stats && d11_match.finished?
            D11TeamTableStat.update_stats_from(d11_match)
            D11TeamTableStat.update_rankings_from(d11_match.d11_match_day)
            data_updates.concat([ "Finished D11 match #{d11_match.name}." ])
          end
        end
      end        
      data_updates
    end
    
end