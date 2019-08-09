class MatchDaysController < ApplicationController
  include Select, StatusEnum

  # TODO: Figure out why specs fail if this is put in StatusEnum
  before_action :authorize_administrator,  only: [:pend, :activate, :finish, :update, :update_stats]

  def current
    premier_league = PremierLeague.current
    if !premier_league.nil?
      match_day = premier_league.current_match_day
      if !match_day.nil?
        redirect_to match_day
      else
        not_found
      end
    else
      not_found
    end
  end

  def pend
    match_day = MatchDay.find(status_enum_params[:id])
    update_status(match_day, :pending)

    match_day.matches.each do |match|
      match.player_match_stats.delete_all
    end
  end

  def activate
    match_day = MatchDay.find(status_enum_params[:id])
    if match_day.pending?
      update_status(match_day, :active)

      PlayerSeasonInfo.where(season: match_day.premier_league.season).each do |player_season_info|
        match = match_day.matches.by_team(player_season_info.team).take
        PlayerMatchStat.create(player: player_season_info.player, match: match, team: player_season_info.team, d11_team: player_season_info.d11_team, position: player_season_info.position, played_position: player_season_info.position.code)
      end
    else
      not_found
    end
  end

  def update
    @match_day = MatchDay.find(params[:id])
    date_str = update_params[:date]

    begin
      if !date_str.empty?
        @match_day.date = Date.parse(date_str)
      else
        @match_day.date = @match_day.date.postpone
      end

      if @match_day.save
        flash[:success] = "Match day date updated."
      else
        flash[:danger] = "The match day date could not be updated."
      end
    rescue ArgumentError
      flash[:danger] = "The date '#{date_str}' is invalid."
    end

    redirect_to @match_day
  end

  def update_stats
    @match_day = MatchDay.find(params[:id])

    @match_day.matches.each do |match|
      TeamTableStat.update_stats_from(match)
    end
    TeamTableStat.update_rankings_from(@match_day)

    @match_day.d11_match_day.d11_matches.each do |d11_match|
      if d11_match.finished?
        D11TeamTableStat.update_stats_from(d11_match)
      end
    end
    D11TeamTableStat.update_rankings_from(@match_day.d11_match_day)

    flash[:success] = "Table statistics updated."

    redirect_to @match_day
  end

  private
    def update_params
      params.require(:match_day).permit(:date)
    end

end
