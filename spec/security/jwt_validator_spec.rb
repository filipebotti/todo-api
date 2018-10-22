require 'jwt'
require './app/security/jwt_validator'

RSpec.describe JWTValidator do

	describe '#is_invalid?' do
		context "with invalid token" do
			jwt = JWTValidator.new("")
			it  { expect(jwt.is_invalid?).to be(true) }			
		end

		context "with valid token" do
			jwt = JWTValidator.new(JWTValidator.encode({ user_id: 1 }))
			it { expect(jwt.is_invalid?).to be(false)}
		end
	end

	describe '#is_expired?' do
		context "with an expired token" do
			jwt = JWTValidator.new(JWTValidator.encode({ exp: -2.day.from_now.to_i }))
			it { expect(jwt.is_expired?).to be(true) }
		end

		context "with a not expired token" do
			jwt = JWTValidator.new(JWTValidator.encode({ exp: 1.day.from_now.to_i }))
			it { expect(jwt.is_expired?).to be(false) }
		end
	end

	describe '#is_payload_invalid?' do
		context "with an invalid payload" do
			jwt = JWTValidator.new(JWTValidator.encode({  }))
			it { expect(jwt.is_payload_invalid?).to be(true) }
		end

		context "with a valid payload" do
			jwt = JWTValidator.new(JWTValidator.encode({ token_type: 'vice_token' }))
			it { expect(jwt.is_payload_invalid?).to be(false)}
		end
	end

	describe '#payload' do
		context "returns the same encoded payload" do
			it "includes all keys" do
				payload = {
					user_id: 1,
					exp: 1.day.from_now.to_i,
					token_type: 'vice_token'
				}
				jwt = JWTValidator.new(JWTValidator.encode(payload))
				expect(jwt.payload).to include(
					"user_id" => payload[:user_id],
					"exp" => payload[:exp],
					"token_type" => payload[:token_type]
				)
			end
		end
	end

	describe '#encode' do
		it 'returns an encoded string' do
			encoded = JWTValidator.encode({})
			expect(encoded).to be_an(String)
		end

		it 'uses HS256 algorithm' do
			payload = { user_id: 1, exp: 1.day.from_now.to_i }
			jwt = JWTValidator.new(JWTValidator.encode(payload))
			expect(jwt.decoded[1]["alg"]).to eq("HS256")
		end
	end

	describe '#decoded' do
		it 'returns an array with decoded info' do
			payload = { user_id: 1, exp: 1.day.from_now.to_i }
			jwt = JWTValidator.new(JWTValidator.encode(payload))
			expect(jwt.decoded).to be_an(Array)
			expect(jwt.decoded.length).to be >= 2
			expect(jwt.decoded[0]).to include(
				"user_id" => payload[:user_id],
				"exp" => payload[:exp]
			)			
		end
	end
end