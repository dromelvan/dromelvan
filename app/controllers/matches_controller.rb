class MatchesController < ApplicationController
  layout "modal", only: [ :edit_match_stats ]
  include Select, StatusEnum

  before_action :authorize_administrator,  only: [:pend, :activate, :finish, :update, :edit_match_stats, :update_match_stats]

  def update
    @match = Match.find(params[:id])
    datetime_str = update_params[:datetime]

    begin    
      if !datetime_str.empty?
        @match.datetime = DateTime.parse(datetime_str)
      else 
        @match.datetime = @match.postpone
      end
      
      if @match.save
        flash[:success] = "Match datetime updated."
      else
        flash[:danger] = "The match datetime could not be updated."
      end      
    rescue ArgumentError
      flash[:danger] = "The datetime '#{datetime_str}' is invalid."
    end
    
    redirect_to @match.match_day
  end

  def edit_match_stats
    @match = Match.find(params[:id])
  end
  
  def update_match_stats    
    match_stats_file = params[:match_stats_file]
    update_table_stats = params[:update_table_stats] == "true"
    begin
      match = Match.find(params[:id])
      session[:upload_result] = UploadMatchStatsFile.new(match, update_table_stats).upload(match_stats_file)

      if !session[:upload_result][:validation_errors].any? && !session[:upload_result][:data_errors].any? && !session[:upload_result][:missing_players].any?
        flash[:success] = [ "Match data updated." ].concat(session[:upload_result][:data_updates])
      end

      redirect_to match
    ensure
      # Not strictly necessary, just so we don't get loads and loads of files
      # before they're garbage collected.
      match_stats_file.tempfile.unlink
    end
  end

  def postpone 
    match = Match.find(params[:id])
    if !match.postponed?
      match.postpone
      match.save
      flash[:success] = "Match postponed."
    else
      flash[:danger] = "The match was already postponed."
    end
    redirect_to match.match_day
  end
      
  private
    def update_params
      params.require(:match).permit(:datetime)
    end

end
