class D11Match < ActiveRecord::Base
  
  belongs_to :home_d11_team, class_name: D11Team, foreign_key: :home_d11_team_id
  belongs_to :away_d11_team, class_name: D11Team, foreign_key: :away_d11_team_id
  belongs_to :d11_match_day, touch: true
  has_many :d11_team_match_squad_stats, dependent: :restrict_with_exception

  enum status: [ :pending, :active, :finished ]
  
  default_scope -> { joins(:d11_match_day).order('d11_match_days.date, d11_matches.id').readonly(false) }
  scope :by_seasons, -> { joins(d11_match_day: [d11_league: :season]) }

  after_initialize :init  
  before_validation :update_status, :update_goals, :update_elapsed

  validates :home_d11_team, presence: true
  validates :away_d11_team, presence: true
  validates :d11_match_day, presence: true  
  validates :home_team_goals, numericality: { greater_than_or_equal_to: 0 }
  validates :away_team_goals, numericality: { greater_than_or_equal_to: 0 }
  validates :home_team_points, presence: true
  validates :away_team_points, presence: true
  validates :elapsed, presence: true
  validates :status, presence: true

  def name
    "#{home_d11_team.code} vs #{away_d11_team.code}"
  end
  
  def result(d11_team)
    update_goals
    if finished? && (d11_team == home_d11_team or d11_team == away_d11_team)
      if home_team_goals == away_team_goals
        :draw
      elsif d11_team == home_d11_team && home_team_goals > away_team_goals
        :win
      elsif d11_team == away_d11_team && away_team_goals > home_team_goals
        :win
      else
        :loss
      end
    else
      nil
    end    
  end

  def points(d11_team)
    result = result(d11_team)
    if result == :draw
      1      
    elsif result == :win
      3
    elsif result == :loss
      0
    else
      nil
    end    
  end
  
  def goals_for(d11_team)
    if d11_team == home_d11_team
      home_team_goals
    elsif d11_team == away_d11_team
      away_team_goals
    else
      0
    end
  end
  
  def goals_against(d11_team)
    if d11_team == home_d11_team
      away_team_goals
    elsif d11_team == away_d11_team
      home_team_goals
    else
      0
    end
  end
  
  def D11Match.by_season(season)
    by_seasons.where(seasons: {id: season.id})
  end
  
  def D11Match.by_d11_team(d11_team)
    D11Match.where("d11_matches.home_d11_team_id = ? OR d11_matches.away_d11_team_id = ?", d11_team.id, d11_team.id)
  end

  def D11Match.by_date(date)
    all.reject { |d11_match|
      datetime = Match.by_d11_match(d11_match).pluck(:datetime, :id).last.first # See D11MatchDay.match_dates
      datetime.nil? || datetime.to_date != date
    }
  end
  
  private
    def init
      self.home_team_goals ||= 0
      self.away_team_goals ||= 0
      self.home_team_points ||= 0
      self.away_team_points ||= 0
      self.elapsed ||= "N/A"
      self.status ||= 0
    end

    def update_status
      # We're doing this in before_validation so d11_match_day might be nil here.
      # If there are no d11_team_match_squad_stats then the setup of the match isn't final in some way so let's not bother then either.
      if !d11_match_day.nil? && !d11_team_match_squad_stats.empty?
        if d11_match_day.match_day.pending?
          self.status = :pending
        elsif d11_match_day.match_day.active?
          players_not_played = 0
          
          d11_team_match_squad_stats.each do |d11_team_match_squad_stat|            
            players_not_played += d11_team_match_squad_stat.players_not_played
          end
          
          if players_not_played > 0
            self.status = :active
          else
            self.status = :finished
          end
        elsif d11_match_day.match_day.finished?
          self.status = :finished
        end
      end
    end
    
    def update_team_points
      d11_team_match_squad_stat = d11_team_match_squad_stats.where(d11_team: home_d11_team).take
      if !d11_team_match_squad_stat.nil?
        self.home_team_points = d11_team_match_squad_stat.points
      end
      d11_team_match_squad_stat = d11_team_match_squad_stats.where(d11_team: away_d11_team).take
      if !d11_team_match_squad_stat.nil?
        self.away_team_points = d11_team_match_squad_stat.points
      end      
    end
    
    def update_goals
      update_team_points
      
      self.home_team_points ||= 0
      self.away_team_points ||= 0      
      
      if self.home_team_points > 0 then
        self.home_team_goals = (home_team_points / 5) + 1
      else
        self.home_team_goals = 0
      end
      
      if self.away_team_points > 0 then
        self.away_team_goals = (away_team_points / 5) + 1
      else
        self.away_team_goals = 0
      end
    end
    
    def update_elapsed
      if pending?
        self.elapsed = "N/A"
      elsif active?
        count = 0
        d11_team_match_squad_stats.each do |d11_team_match_squad_stat|
          count += d11_team_match_squad_stat.players_played + d11_team_match_squad_stat.players_missing
        end        
        self.elapsed = "#{count * 4}"
      elsif finished?
        self.elapsed = "FT"
      end
    end
  
end
