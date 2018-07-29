class Api::V1::SeasonsController < Api::V1::BaseController

  def index
    seasons = Season.all
    render json: seasons
  end
  
  def show
    season = Season.find(params[:id])  
    render json: season
  end

  def current
    season = Season.current
    
    if !season.nil?
      render json: season
    else
      not_found
    end
  end
  
end