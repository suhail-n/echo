require 'rails_helper'

RSpec.describe "workout_plans/edit", type: :view do
  let(:user) { create(:user) }
  let(:workout_plan) {
    WorkoutPlan.create!(
      name: "MyString",
      user: user,
      is_template: false,
      is_published: false
    )
  }

  before(:each) do
    assign(:workout_plan, workout_plan)
  end

  it "renders the edit workout_plan form" do
    render

    assert_select "form[action=?][method=?]", workout_plan_path(workout_plan), "post" do
      assert_select "input[name=?]", "workout_plan[name]"

      assert_select "input[name=?]", "workout_plan[user_id]"

      assert_select "input[name=?]", "workout_plan[is_template]"

      assert_select "input[name=?]", "workout_plan[is_published]"
    end
  end
end
