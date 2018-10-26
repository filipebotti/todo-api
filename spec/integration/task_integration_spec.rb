require 'rails_helper'

RSpec.describe 'Task Requests', :type => :request do

    describe "get tasks" do
        context "has no Authorization headers" do
            before do
                get '/api/tasks'
            end

            it { expect(response).to have_http_status(:unauthorized)}
        end

        context "user tasks" do
            let!(:user) { FactoryBot.create(:user) }
            let!(:task) { FactoryBot.create(:task) }
            let!(:deleted_task) { FactoryBot.create(:deleted_task) }

            before do
                payload = { 
                    user_id: user.id,
                    exp: 1.day.from_now.to_i,
                    token_type: 'vice_token'
                }
                @token = JWTValidator.encode(payload)            
                
            end

            it "should respond with status code :ok" do
                get '/api/tasks', params:{}, headers: { "Authorization" => @token }
                expect(response).to have_http_status(:ok) 
            end

            it "only not discarded" do
                get '/api/tasks', params:{}, headers: { "Authorization" => @token }
                expect(json.length).to be > 0
                json.each do |item|
                    expect(item).to include("deleted_at")
                    expect(item["deleted_at"]).to be_nil
                end
            end

            it 'only descarded' do
                get '/api/tasks?status=discarded', params:{}, headers: { "Authorization" => @token }
                expect(json.length).to be > 0
                json.each do |item|
                    expect(item).to include("deleted_at")
                    expect(item["deleted_at"]).to_not be_nil
                end
            end

            it 'all tasks' do
                get '/api/tasks?status=all', params:{}, headers: { "Authorization" => @token }
                expect(json.length).to be > 0
                json.each do |item|
                    expect(item).to include("deleted_at")
                    expect(item["deleted_at"]).to eq(nil) | be_a(String)
                end
            end
        end
    end

        context "update task" do
            let!(:user) { FactoryBot.create(:user) }
            let!(:task) { FactoryBot.create(:task) }

            context "valid description" do
                before do
                    payload = { 
                        user_id: user.id,
                        exp: 1.day.from_now.to_i,
                        token_type: 'vice_token'
                    }
                    token = JWTValidator.encode(payload)                 

                    put "/api/tasks/#{task.id}", params:{ task: { description: "updated_task" }}, headers: { "Authorization" => token }
                end                           

                it { expect(response).to have_http_status(:ok) }
                it { expect(json["description"]).to eq("updated_task")}     
            end

            context "invalid description" do
                before do
                    payload = { 
                        user_id: user.id,
                        exp: 1.day.from_now.to_i,
                        token_type: 'vice_token'
                    }
                    token = JWTValidator.encode(payload)                 

                    put "/api/tasks/#{task.id}", params:{ task: { description: "" }}, headers: { "Authorization" => token }
                end

                it { expect(response).to have_http_status(:unprocessable_entity) }
                it { expect(json["description"]).to include("can't be blank")}
            end
        end

        context "create task" do

            let!(:user) { FactoryBot.create(:user) }
            
            before do 
                payload = { 
                    user_id: user.id,
                    exp: 1.day.from_now.to_i,
                    token_type: 'vice_token'
                }
                @token = JWTValidator.encode(payload) 
            end

            context "valid params" do
                before do
                    post "/api/tasks", params:{ task: { description: "new task", user_id: user.id }}, headers: { "Authorization" => @token }
                end
                
                it { expect(response).to have_http_status(:created) }
                it { expect(json["task"]["id"]).to_not be_nil }
            end

            context "without description" do
                before do
                    post "/api/tasks", params:{ task: { user_id: user.id }}, headers: { "Authorization" => @token }
                end

                it { expect(response).to have_http_status(:unprocessable_entity) }
                it { expect(json["description"]).to include("can't be blank")}
            end
        end

        context "discard task" do

            let!(:user) { FactoryBot.create(:user) }
            let!(:task) { FactoryBot.create(:task) }
            
            before do 
                payload = { 
                    user_id: user.id,
                    exp: 1.day.from_now.to_i,
                    token_type: 'vice_token'
                }
                @token = JWTValidator.encode(payload) 
                delete "/api/tasks/#{task.id}", params: {}, headers: { "Authorization" => @token }
            end

            it { expect(response).to have_http_status(:ok) }
            it "should updated deleted_at field" do
                get "/api/tasks/#{task.id}", params: {}, headers: { "Authorization" => @token }

                expect(json["deleted_at"]).to_not be_nil
            end

        end
end