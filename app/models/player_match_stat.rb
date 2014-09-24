class PlayerMatchStat < ActiveRecord::Base
  include PlayerStats
  
  belongs_to :player
  belongs_to :match  
  belongs_to :team
  belongs_to :d11_team
  belongs_to :position
  
  default_scope -> { joins(:match).order('matches.datetime').readonly(false) }
  
  after_initialize :init
  before_validation :update_played_position
  
  validates :player, presence: true
  validates :match, presence: true
  validates :team, presence: true
  validates :d11_team, presence: true
  validates :position, presence: true      
  validates :played_position, length: {minimum: 1, maximum: 5}
  validates :lineup, inclusion: 0..2
  validates :substitution_on_time, presence: true, inclusion: 0..90
  validates :substitution_off_time, presence: true, inclusion: 0..90    
  validates :yellow_card_time, presence: true, inclusion: 0..90
  validates :red_card_time, presence: true, inclusion: 0..90    
  validates :man_of_the_match, inclusion: [true, false]
  validates :shared_man_of_the_match, inclusion: [true, false]

  def update_points
    # Caluclates points for season 2014-2015 rules
    self.points = 0
    
    if self.lineup == 2 || self.substitution_on_time > 0
      if self.red_card_time > 0
        self.points -= 4
      elsif self.yellow_card_time > 0
        self.points -= 1
      end
      
      if self.position.defender?
        if self.goals_conceded == 0
          self.points += 4;
        elsif self.goals_conceded >= 2
          self.points -= (self.goals_conceded - 1)
        end
      end

      if self.man_of_the_match?
        self.points += 4
      elsif self.shared_man_of_the_match?
        self.points += 2
      end

      case self.rating
        # 0 should only be for did not participate. Do this manually if some player
        # somehow manages to get a real rating of 0 (which seems very unlikely).
        when 0 then self.points -= 0
        when 1..49 then self.points -= 6
        when 50..149 then self.points -= 5
        when 150..249 then self.points -= 4
        when 250..349 then self.points -= 3
        when 350..449 then self.points -= 2
        when 450..549 then self.points -= 1
        when 550..649 then self.points += 0
        when 650..749 then self.points += 1
        when 750..849 then self.points += 2
        when 850..949 then self.points += 3
        when 950..1000 then self.points += 5
      end
        
      self.points += (4 * self.goals) - (4 * self.own_goals)
      self.points += (2 * self.goal_assists)
      
    elsif self.position.defender?
      self.points = -1      
    end
    self.points
  end
  
  def PlayerMatchStat.by_match_day(match_day)
    joins(:match).where(matches: {match_day_id: (!match_day.nil? ? match_day.id : -1)}).readonly(false)
  end

  def PlayerMatchStat.by_d11_match_day(d11_match_day)
    by_match_day(d11_match_day.match_day)
  end
  
  private
  
    def init
      self.played_position ||= ""
      self.lineup ||= 0
      self.substitution_on_time ||= 0
      self.substitution_off_time ||= 0
      self.yellow_card_time ||= 0
      self.red_card_time ||= 0
      self.man_of_the_match ||= false
      self.shared_man_of_the_match ||= false
    end
    
    def update_played_position
      if !self.position.nil? then
        self.played_position ||= self.position.code
      end      
    end
    
end
