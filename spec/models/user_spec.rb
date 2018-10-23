require 'rails_helper'

RSpec.describe User, :type => :model do
    it "valid with valid attributes" do
        user = build(:user)
        expect(user).to be_valid
    end

    it "invalid without name" do
        user = build(:user, name: nil)
        user.valid?
        expect(user.errors[:name]).to include("can't be blank")
        expect(user).to_not be_valid
    end
    
    it "invalid without username" do
        user = build(:user, username: nil)
        user.valid?
        expect(user.errors[:username]).to include("can't be blank")
        expect(user).to_not be_valid
    end

    it "invalid without password" do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
        expect(user).to_not be_valid
    end    
end