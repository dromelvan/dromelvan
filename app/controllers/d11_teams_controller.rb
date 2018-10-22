class D11TeamsController < ApplicationController
  include SelectSeason, Select, Fixtures

  layout "modal", only: [ :edit_club_crest, :edit ]
  before_action :authorize_owner, only: [:edit_club_crest, :update_club_crest]

  def edit_club_crest
    edit
  end

  def update_club_crest
    update
  end

  private
    def authorize_owner
      d11_team = D11Team.find(params[:id])
      not_found unless administrator_signed_in? || (user_signed_in? && current_user.active_d11_team == d11_team)
    end

    def resource_params
      params.require(:d11_team).permit(:club_crest)
    end

end
