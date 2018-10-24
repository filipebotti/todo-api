require 'rails_helper'

RSpec.describe Task, :type => :model do
    
    context "with valid params" do
        it { expect(build(:task)).to be_valid }
        it "should has an user" do
            expect(build(:task).user).to be_an(User)
        end
    end

    context "with invalid params" do
        it { expect(build(:task, description: nil)).to_not be_valid }
        it { expect(build(:task, user: nil)).to_not be_valid }
    end
end