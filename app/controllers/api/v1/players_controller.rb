class Api::V1::PlayersController < Api::V1::BaseController
  
  def show
    player = Player.find(params[:id])    
    render json: player
  end
  
  def named
    name = params[:name]
    name = name.gsub('+',' ')
    players = Player.named(name)
    render json: players
  end
    
end