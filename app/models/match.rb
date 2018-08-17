class Match < ActiveRecord::Base
  
  belongs_to :home_team, class_name: Team, foreign_key: :home_team_id
  belongs_to :away_team, class_name: Team, foreign_key: :away_team_id
  belongs_to :match_day, touch: true
  belongs_to :stadium
  has_many :player_match_stats, dependent: :restrict_with_exception
  has_many :goals, dependent: :restrict_with_exception
  has_many :cards, dependent: :restrict_with_exception
  has_many :substitutions, dependent: :restrict_with_exception
  has_many :team_match_squad_stats, dependent: :restrict_with_exception

  enum status: [ :pending, :active, :finished ]

  # This would let us enter times in UTC and save them in that time in UTC.
  # I.e 15:00 would be save as 15:00 UTC instead of 13:00 UTC. But I'm not
  # sure we actually want that after all so we'll leave it here so we'll
  # remember how to do it if it turns out we want it and just comment it.
  # before_save { self.datetime = datetime + Time.zone.utc_offset }

  default_scope -> { order(:datetime, :id) }
  scope :by_seasons, -> { joins(match_day: [premier_league: :season]) }

  after_initialize :init
  before_validation :update_default_properties, on: :create
  before_validation :update_elapsed, :update_goals

  validates :home_team, presence: true
  validates :away_team, presence: true
  validates :match_day, presence: true  
  validates :stadium, presence: true
  validates :home_team_goals, numericality: { greater_than_or_equal_to: 0 }
  validates :away_team_goals, numericality: { greater_than_or_equal_to: 0 }
  validates :previous_home_team_goals, numericality: { greater_than_or_equal_to: 0 }
  validates :previous_away_team_goals, numericality: { greater_than_or_equal_to: 0 }  
  validates :datetime, presence: true
  validates :elapsed, presence: true
  validates :status, presence: true
  validates :whoscored_id, numericality: { greater_than: 0 }

  def postponed?
    # Have to do a to_datetime here since the datetime might be a TimeWithZone.
    datetime == nil || datetime.to_datetime.postponed?
  end
  
  def postpone
    # Have to do a to_datetime here since the datetime might be a TimeWithZone.
    self.datetime = datetime.to_datetime.postpone
  end

  def date_s
    (postponed? ? "Postponed" : datetime.to_date.to_s(:match_date))
  end
  
  def short_date_s
    (postponed? ? "Postponed" : datetime.to_date.to_s(:match_date_short))
  end

  def short_date_no_weekday_s
    (postponed? ? "PP" : datetime.to_date.to_s(:match_date_short_no_weekday))
  end

  def shortest_date_s
    (postponed? ? "PP" : datetime.to_date.to_s(:match_date_shortest))
  end
  
  def kickoff_time_s
    (postponed? ? "PP" : datetime.to_s(:kickoff_time))
  end
    
  def name
    "#{home_team.code} vs #{away_team.code}"
  end

  def result(team)
    if finished? && (team == home_team or team == away_team)
      if home_team_goals == away_team_goals
        :draw
      elsif team == home_team && home_team_goals > away_team_goals
        :win
      elsif team == away_team && away_team_goals > home_team_goals
        :win
      else
        :loss
      end
    else
      nil
    end    
  end

  def points(team)
    result = result(team)
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
  
  def goals_for(team)
    if team == home_team
      home_team_goals
    elsif team == away_team
      away_team_goals
    else
      0
    end
  end
  
  def goals_against(team)
    if team == home_team
      away_team_goals
    elsif team == away_team
      home_team_goals
    else
      0
    end
  end
  
  def Match.by_season(season)
    by_seasons.where(seasons: {id: season.id})
  end

  def Match.by_team(team)
    Match.where("matches.home_team_id = ? OR matches.away_team_id = ?", team.id, team.id)
  end

  def Match.by_date(date)
    Match.where(datetime: date.beginning_of_day..date.end_of_day)
  end
  
  def Match.by_d11_match(d11_match)
    matches = Match.joins(:player_match_stats, match_day: [d11_match_day: :d11_matches])
             .where(d11_matches: { id: d11_match.id })
             .where("player_match_stats.d11_team_id = d11_matches.home_d11_team_id OR player_match_stats.d11_team_id = d11_matches.away_d11_team_id")
             .distinct
    if !matches.any? then
      matches = Match.joins(match_day: [d11_match_day: :d11_matches])
                .where(d11_matches: { id: d11_match.id })
    end
    matches
  end
  
  private  
    def init
      self.status ||= :pending
      self.elapsed ||= "N/A"
      self.home_team_goals ||= 0
      self.away_team_goals ||= 0
      self.previous_home_team_goals ||= 0
      self.previous_away_team_goals ||= 0      
    end
    
    def update_default_properties
      if self.home_team.present? then
        self.stadium ||= home_team.stadium
      end
      
      if self.match_day.present? then
        self.datetime ||= self.match_day.date.to_time
      end      
    end
    
    def update_goals
      self.previous_home_team_goals = self.home_team_goals
      self.previous_away_team_goals = self.away_team_goals
      self.home_team_goals = goals.where(team: home_team).count
      self.away_team_goals = goals.where(team: away_team).count
    end
    
    def update_elapsed
      if pending?
        self.elapsed = "N/A"
      elsif finished?
        self.elapsed = "FT"
      end
    end
    
end
