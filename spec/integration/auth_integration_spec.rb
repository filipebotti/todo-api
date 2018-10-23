require 'rails_helper'

RSpec.describe "Auth Requests", :type => :request do

    describe "/auth" do
        context "with valid params" do
            let!(:user) { FactoryBot.create(:user) }

            before do
                post '/auth', params: { username: 'john.doe', password: "123456" } 
            end

            it 'return an acess token if valid params' do
                expect(json["access_token"]).to_not be_nil
                expect(json["access_token"]).to be_a(String)                
            end
            
            it 'should respond with status code :ok' do
                expect(response).to have_http_status(:ok)
            end
        end

        context "without params" do
            let!(:user) { FactoryBot.create(:user) }

            before do
                post '/auth', params: { username: 'john.doe' } 
            end

            it 'has an error message' do                
                expect(json["error"]).to_not be_nil
                expect(json["error"]).to be_a(String)
            end
            
            it 'should respond with status code :unauthorized' do
                expect(response).to have_http_status(:unauthorized)
            end
        end

        context "with invalid params" do
            let!(:user) { FactoryBot.create(:user) }

            before do
                post '/auth', params: { username: 'john.doe', password: "123" } 
            end

            it 'has an error message' do                
                expect(json["error"]).to_not be_nil
                expect(json["error"]).to be_a(String)
            end
            
            it 'should responde with status code :unauthorized' do
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end
end