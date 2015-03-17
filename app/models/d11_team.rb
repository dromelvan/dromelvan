class D11Team < ActiveRecord::Base
  include NameScope
  include TeamPlayers
  
  belongs_to :owner, class_name: :User, foreign_key: :owner_id
  belongs_to :co_owner, class_name: :User, foreign_key: :co_owner_id
  has_many :home_d11_matches, class_name: D11Match, foreign_key: :home_d11_team_id, dependent: :restrict_with_exception
  has_many :away_d11_matches, class_name: D11Match, foreign_key: :away_d11_team_id, dependent: :restrict_with_exception    
  has_many :player_match_stats, dependent: :restrict_with_exception
  has_many :player_season_infos, dependent: :restrict_with_exception
  has_many :transfer_listings, dependent: :restrict_with_exception
  has_many :d11_team_table_stats, dependent: :restrict_with_exception
  has_many :d11_team_registrations, dependent: :restrict_with_exception
  has_many :d11_team_match_squad_stats, dependent: :restrict_with_exception
  has_many :d11_team_season_squad_stats, dependent: :restrict_with_exception

  default_scope -> { order(name: :asc) }
  
  has_attached_file :club_crest, styles: { icon: [ "16x16^", :png], tiny: ["32x32^", :png], small: ["64x64^", :png], large: ["128x128^", :png] },
                                 convert_options: {
                                    icon: "-gravity Center -crop 16x16+0+0 +repage",
                                    tiny: "-gravity Center -crop 32x32+0+0 +repage",
                                    small: "-gravity Center -crop 64x64+0+0 +repage",
                                    large: "-gravity Center -crop 128x128+0+0 +repage"
                                  },
                                  default_url: "/assets/missing/club-crest-:style.png",
                                  url: "/images/d11_club_crest/:style/:id.:extension",
                                  path: ":rails_root/public/images/d11_club_crest/:style/:id.:extension"

  validates :owner, presence: true
  validates :name, presence: true, length: { maximum: 25 }, uniqueness: { case_sensitive: false }
  validates :code, uniqueness: { case_sensitive: false, allow_blank: true }
  validates_length_of :code, is: 3, allow_nil: true
  validates :dummy, inclusion: [true, false] 

  validates_attachment_size :club_crest, less_than: 5.megabytes
  validates_attachment_content_type :club_crest, content_type: [ "image/jpeg", "image/jpg", "image/gif", "image/png" ]

  private  
    def init
      self.dummy ||= false
    end

end
