class PlayerSeasonInfo < ActiveRecord::Base

  belongs_to :player, touch: true
  belongs_to :season, touch: true
  belongs_to :team, touch: true
  belongs_to :d11_team
  belongs_to :position

  default_scope -> { joins(:season).order("seasons.date desc") }
  scope :name_order, -> { joins(:player).order("players.last_name, players.first_name")}

  after_initialize :init

  validates :player, presence: true
  validates :season, presence: true
  validates :team, presence: true
  validates :d11_team, presence: true
  validates :position, presence: true
  validates :value, presence: true, inclusion: { in: 0..500, message: "%{value} is invalid" }
  validates :player_id, uniqueness: {scope: :season_id}

  def PlayerSeasonInfo.by_player(player)
    where(player: player)
  end

  def PlayerSeasonInfo.by_season(season)
    where(season: season)
  end

  def PlayerSeasonInfo.current(player)
    by_player_and_season(player, Season.current)
  end

  def PlayerSeasonInfo.by_player_and_season(player, season)
    player_season_info = by_player(player).by_season(season).first
    if player_season_info.nil?
      player_season_info = new(player: player, season: Season.current)
      player_season_infos = by_player(player)
      if player_season_infos.size > 0
        player_season_info.position = player_season_infos.first.position
      end
    end
    player_season_info
  end

  private
    def init
      self.team ||= Team.where(name: "None").first
      self.d11_team ||= D11Team.where(name: "None").first
      self.position ||= Position.where(name: "Unknown").first
      self.value ||= 0
    end

end
