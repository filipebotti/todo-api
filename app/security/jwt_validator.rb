#JWTValidotr class to validate jwt token
class JWTValidator
	

	def initialize(token)
		@jwt_token = decode(token)		
	end

	def is_invalid?
		!@jwt_token[0][:invalid].nil? && @jwt_token[0][:invalid]
	end

	def is_expired?
		!@jwt_token[0][:expired].nil? && @jwt_token[0][:expired]
	end

	def self.encode(payload = {})
		JWT.encode payload, Rails.application.secrets.secret_jwt, 'HS256'
	end

	def payload
		@jwt_token[0]
	end

	def decoded
		@jwt_token
	end

	def is_payload_invalid?
		!payload['token_type'].present? || payload['token_type'].present? && payload['token_type'] != 'vice_token'
	end



	private 
	def decode(jwt_hash)
		begin
			JWT.decode jwt_hash, Rails.application.secrets.secret_jwt, true, { :algorithm => 'HS256'}
		rescue JWT::ExpiredSignature
			[{ expired: true }]
		rescue 
			[{ invalid: true }]
		end
	end
end