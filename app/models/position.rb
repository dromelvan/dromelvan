class Position < ActiveRecord::Base
  
  default_scope -> { order(sort_order: :asc) }
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :defender, inclusion: [true, false]
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :sort_order, presence: true, uniqueness: true, numericality: { greater_than: 0 }

end
