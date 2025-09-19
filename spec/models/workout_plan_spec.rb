require 'rails_helper'

RSpec.describe WorkoutPlan, type: :model do
  describe "validations" do
    context "when creating a workout plan" do
      let(:user) { build(:user) }
      let(:plan) { build(:workout_plan, user: user) }

      it "is valid with a name and user" do
        expect(plan).to be_valid
        # run this test with command `rspec spec/models/workout_plan_spec.rb` to ensure it passes
      end

      it "is invalid without a user" do
        plan.user = nil
        expect(plan).not_to be_valid
        expect(plan.errors[:user]).to be_present
      end
    end
  end
end
