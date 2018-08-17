class AddPreviousGoalsToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :previous_home_team_goals, :integer
    add_column :matches, :previous_away_team_goals, :integer
    
    reversible do |dir|
      dir.up do
        Match.update_all('previous_home_team_goals = home_team_goals')
        Match.update_all('previous_away_team_goals = away_team_goals')
      end
    end    
  end
end
