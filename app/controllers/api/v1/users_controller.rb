class Api::V1::UsersController < Api::V1::BaseController
  rescue_from ActionController::ParameterMissing, with: :not_found
  
  def request_authentication_token
    user = User.where(email: request_authentication_token_params[:email]).first
    if !user.nil? && user.valid_password?(request_authentication_token_params[:password])
      user.update_authentication_token
      user.save
      render json: user.to_json(only: [:authentication_token])
    else
      not_found
    end
  end
  
  private
    def request_authentication_token_params
      params.require(:user).permit(:email, :password)
    end
end