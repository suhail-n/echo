require 'rails_helper'

RSpec.describe "workout_plans/index", type: :view do
  before(:each) do
    @user = build(:user)
    @plans = [
      create(:workout_plan, user: @user, is_template: false),
      create(:workout_plan, user: @user)
    ]
    assign(:workout_plans, @plans)
  end

  it "renders a list of workout_plans" do
    render
    puts "inspect workout_plans=#{@plans.inspect}"
    cell_selector = 'div#workout_plans > div'
    assert_select cell_selector, count: 2
    @plans.each do |plan|
      cell_selector_workout_plan = "div#workout_plan_#{plan.id}"
      assert_select cell_selector_workout_plan, count: 1
      assert_select cell_selector_workout_plan, text: Regexp.new("Name: #{plan.name}".to_s), count: 1
      assert_select cell_selector_workout_plan, text: Regexp.new("Is template: #{plan.is_template ? 'Yes' : 'No'}"), count: 1
      assert_select cell_selector_workout_plan, text: Regexp.new("Is published: #{plan.is_published ? 'Yes' : 'No'}"), count: 1
    end
  end
end
