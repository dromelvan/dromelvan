class Api::V1::BaseController < ApplicationController

  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :not_found

  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  private
    def api_error(error_data)
      api_error = {}
      api_error[:error] = error_data
      render json: api_error.to_json, status: :not_found
    end

    def not_found
      return api_error(status: 404, message: 'Not found')
    end

    def authorize_administrator
      user = User.where(email: authentication_parameters[:email]).first
      not_found unless !user.nil? && user.authentication_token == authentication_parameters[:authentication_token].gsub(' ','+') && user.try(:administrator?)
    end

    def authentication_parameters
      params.require(:user).permit(:email, :authentication_token)
    end
end
