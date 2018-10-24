require 'rails_helper'
require 'jwt'
require './app/security/jwt_validator'

RSpec.describe "User Request", :type => :request do

    let!(:user) { FactoryBot.create(:user) }

    describe 'get user by id' do       

        context "no Authorization headers" do
            it "should respond with status code :unauthorized" do                
                get '/users/:id', params: { id: user.id }
                expect(response).to have_http_status(:unauthorized)
            end
        end

        context "is not himself" do
            before do
                payload = { 
                    user_id: user.id,
                    exp: 1.day.from_now.to_i,
                    token_type: 'vice_token'
                }
                token = JWTValidator.encode(payload)            
                get "/users/1", params: {}, headers: { 'Authorization' => token }
            end
        
            it 'should responde with status code :unauthorized' do                
                expect(response).to have_http_status(:unauthorized)
            end
        end

        context "is himself" do
            before do
                payload = { 
                    user_id: user.id,
                    exp: 1.day.from_now.to_i,
                    token_type: 'vice_token'
                }
                token = JWTValidator.encode(payload)            
                get "/users/#{user.id}", params: { }, headers: { 'Authorization' => token }
            end

            it "should respond with status code :ok" do
                expect(response).to have_http_status(:ok)
            end
            it "returns the user" do                
                expect(json["id"]).to_not be_nil
                expect(json["id"]).to eq(user.id)
            end
        end
    end

    describe 'create user' do

        context "with valid params" do
            before do
                data = {
                    name: 'user',
                    username: 'user',
                    password: '123456'
                }

                post '/users', params: { user: data }
            end

            it { expect(response).to have_http_status(:created) }
            it { expect(json["user"]["id"]).to_not be_nil}
            it { expect(json["access_token"]).to_not be_nil }
        end

        context "with invalid params" do

            it "should respond with status :bad_request without password" do
                data = {
                    name: 'user',
                    username: 'user',
                }

                post '/users', params: { user: data }
                expect(response).to have_http_status(:unprocessable_entity)
            end

            it "should respond with status :bad_request without name" do
                data = {
                    username: 'user',
                    password: '123456'
                }

                post '/users', params: { user: data }
                expect(response).to have_http_status(:unprocessable_entity)
            end

            it "should respond with status :bad_request without username" do
                data = {
                    name: 'user',
                    password: '123456'
                }

                post '/users', params: { user: data }
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe 'update user' do

        context 'with no Authorization headers' do
            it "should respond with status code :unauthorized" do
                put "/users/1"
                expect(response).to have_http_status(:unauthorized)
            end
        end

        context 'with valid params' do
            before do
                payload = { 
                    user_id: user.id,
                    exp: 1.day.from_now.to_i,
                    token_type: 'vice_token'
                }
                token = JWTValidator.encode(payload)

                data = {
                    username: 'updated_username',
                }

                put "/users/#{user.id}", params: { user: data }, headers: { "Authorization" => token }
            end
            
            it { expect(response).to have_http_status(:ok) }
            it { expect(json["username"]).to eq("updated_username") }
        end
    end
end