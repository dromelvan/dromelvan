class TransferWindowsController < ApplicationController
  include Select
  layout "modal", only: [ :new ]
  
  def new
    @transfer_window = TransferWindow.new(season: Season.current, status: :pending, transfer_window_number: 0)
    
    previous_transfer_window = TransferWindow.where(season: @transfer_window.season).first
    if !previous_transfer_window.nil?
      @transfer_window.transfer_window_number = previous_transfer_window.transfer_window_number + 1
    end      
    
    if !D11League.current.nil? && !D11League.current.current_d11_match_day.nil?
      @transfer_window.d11_match_day = D11League.current.current_d11_match_day
      @transfer_window.datetime = @transfer_window.d11_match_day.date.to_datetime.change(hour: 22)
    end
  end

  def create
    super
    datetime = @transfer_window.datetime
    datetime = datetime + 2.days
    TransferDay.create(transfer_window: TransferWindow.current, transfer_day_number: 1, status: :pending, datetime: datetime)
  end
  
  def resource_params
    params.require(:transfer_window).permit(:d11_match_day_id, :datetime, :season_id, :status, :transfer_window_number)
  end
  
end
