require 'rails_helper'

RSpec.describe "Auth routing", :type => :routing do
    it "routes /auth to auth#auth" do
        expect(:post => "/api/auth").to route_to(
            :controller => "auth",
            :action => "auth"
        )
    end
end