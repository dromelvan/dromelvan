class PremierLeaguesController < ApplicationController
  include Select, LeagueTable, Stats

  def show
    premier_league = PremierLeague.find(params[:id])
    redirect_to show_table_premier_league_path premier_league 
  end

  def printable_player_list
    @premier_league = PremierLeague.find(params[:id])
  end
  
end
