class D11MatchDaysController < ApplicationController
  include Select

  before_action :authorize_administrator,  only: [:update]
  
  def update
    @d11_match_day = D11MatchDay.find(params[:id])
    date_str = update_params[:date]

    begin    
      if !date_str.empty?
        @d11_match_day.date = Date.parse(date_str)
      else 
        @d11_match_day.date = @d11_match_day.date.postpone
      end
      
      if @d11_match_day.save
        flash[:success] = "D11 Match day date updated."
      else
        flash[:danger] = "The D11 match day date could not be updated."
      end      
    rescue ArgumentError
      flash[:danger] = "The date '#{date_str}' is invalid."
    end
    
    redirect_to @d11_match_day
  end

  private
    def update_params
      params.require(:d11_match_day).permit(:date)
    end
  
end
