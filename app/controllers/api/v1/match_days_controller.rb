class Api::V1::MatchDaysController < Api::V1::BaseController

  def current
    match_day = PremierLeague.current.current_match_day
    
    if !match_day.nil?
      render json: match_day
    else
      not_found
    end
  end
  
  def upcoming
    match_day = PremierLeague.current.current_match_day
    upcoming_match_day = match_day.next
    
    if !upcoming_match_day.nil?
      render json: upcoming_match_day
    else
      not_found
    end
  end
  
end