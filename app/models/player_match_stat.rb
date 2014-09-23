class PlayerMatchStat < ActiveRecord::Base
  
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
  validates :goals, numericality: { greater_than_or_equal_to: 0 }
  validates :goal_assists, numericality: { greater_than_or_equal_to: 0 }
  validates :own_goals, numericality: { greater_than_or_equal_to: 0 }
  validates :goals_conceded, numericality: { greater_than_or_equal_to: 0 }
  validates :yellow_card_time, presence: true, inclusion: 0..90
  validates :red_card_time, presence: true, inclusion: 0..90    
  validates :man_of_the_match, inclusion: [true, false]
  validates :shared_man_of_the_match, inclusion: [true, false]
  validates :rating, inclusion: 0..1000
  validates :points, presence: true, numericality: { only_integer: true }
  
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
      self.goals ||= 0
      self.goal_assists ||= 0
      self.own_goals ||= 0
      self.goals_conceded ||= 0
      self.yellow_card_time ||= 0
      self.red_card_time ||= 0
      self.man_of_the_match ||= false
      self.shared_man_of_the_match ||= false
      self.rating ||= 0
      self.points ||= 0      
    end
    
    def update_played_position
      if !self.position.nil? then
        self.played_position ||= self.position.code
      end      
    end
    
end
