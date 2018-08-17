class AddPreviousGoalsToD11Matches < ActiveRecord::Migration
  def change
    add_column :d11_matches, :previous_home_team_goals, :integer
    add_column :d11_matches, :previous_away_team_goals, :integer
    add_column :d11_matches, :previous_home_team_points, :integer
    add_column :d11_matches, :previous_away_team_points, :integer
    
    reversible do |dir|
      dir.up do
        D11Match.update_all('previous_home_team_goals = home_team_goals')
        D11Match.update_all('previous_away_team_goals = away_team_goals')
        D11Match.update_all('previous_home_team_points = home_team_points')
        D11Match.update_all('previous_away_team_points = away_team_points')        
      end
    end    
    
  end
end
