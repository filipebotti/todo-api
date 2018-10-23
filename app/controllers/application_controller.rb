class ApplicationController < ActionController::API
	before_action :auth_validation

	def auth_validation
		if request.headers['Authorization'].present?
			validator = JWTValidator.new(request.headers['Authorization'])

			if validator.is_invalid? || validator.is_payload_invalid?
				render json: { error: 'Invalid token' }, status: :unauthorized				
			elsif validator.is_expired?
				render json: { erro: 'Token expired' }, status: :unauthorized
			else				
				@current_user ||= User.find(validator.payload["user_id"])
			end			
		else
			render json: { error: 'Missing token' }, status: :unauthorized
		end
	end
end
