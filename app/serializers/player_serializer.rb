class PlayerSerializer < BaseSerializer

  attributes :name, :whoscored_id, :team, :nationality
  
  private
  def team
      object.player_season_infos.first.team.name
  end  

  def nationality
    object.country.name
  end
  
end