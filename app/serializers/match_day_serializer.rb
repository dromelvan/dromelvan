class MatchDaySerializer < BaseSerializer

  attributes :status, :match_day_number

  has_many :matches

  private
    def status
      if object.pending?
        0
      elsif object.active?
        1
      elsif object.finished?
        2
      end
    end
  
end