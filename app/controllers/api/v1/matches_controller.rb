class Api::V1::MatchesController < Api::V1::BaseController
  
  def show
    match = Match.find(params[:id])  
    render json: match
  end

  def by_date
    date = Date.parse(params[:date])
    matches = Match.where(datetime: date.beginning_of_day..date.end_of_day)
    render json: matches
  end
  
  def update
    match = Match.find(params[:id])
    
    datetime_str = update_params[:datetime]
    if !datetime_str.empty?
      match.datetime = DateTime.parse(datetime_str)
    else 
      match.datetime = match.postpone
    end      
    match.save
    
    render json: match
  end
  
  private
    def update_params
      params.require(:match).permit(:datetime)
    end
  
end