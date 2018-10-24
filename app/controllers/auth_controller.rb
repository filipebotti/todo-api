class AuthController < ApplicationController
	skip_before_action :auth_validation

	def auth
		if params[:username] && params[:password]
			user = User.find_by(username: params[:username])

			if user && user.authenticate(params[:password])
				payload = {
					user_id: user.id,
					token_type: 'vice_token',
					exp: 1.day.from_now.to_i
				}

				render json: { access_token: JWTValidator.encode(payload), user: user.as_json(only: [:id, :name, :username])}, status: :ok
			else
				render json: { error: "Incorrect username or password" }, status: :unauthorized
			end
		else
			render json: { error: "Incorrect username or password" }, status: :unauthorized
		end
	end
end
