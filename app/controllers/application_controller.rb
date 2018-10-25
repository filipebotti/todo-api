class ApplicationController < ActionController::API

	before_action :add_cors_headers
	before_action :auth_validation
	
	def add_cors_headers
		origin = request.headers["Origin"]		
		headers['Access-Control-Allow-Origin'] = origin
		headers['Access-Control-Allow-Methods'] = 'POST, GET, PATCH, PUT, DELETE'
		allow_headers = request.headers["Access-Control-Request-Headers"]
		if allow_headers.nil?
			#shouldn't happen, but better be safe
			allow_headers = 'Origin, Authorization, Accept, Content-Type'
		end
		headers['Access-Control-Allow-Headers'] = allow_headers		
		headers['Access-Control-Max-Age'] = '1728000'
	end

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
