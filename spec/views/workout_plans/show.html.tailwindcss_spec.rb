require 'rails_helper'

RSpec.describe "workout_plans/show", type: :view do
  before(:each) do
    @user = build(:user)
    assign(:workout_plan, WorkoutPlan.create!(
      name: "Name",
      user: @user,
      is_template: false,
      is_published: false
    ))
  end

  it "renders attributes in <p>" do
    render
    puts "User id=#{@user.id}"
    expect(rendered).to match(/Name/)
    # user id is matched
    expect(rendered).to match(/#{@user.id}/)

    expect(rendered).to match(/No/)
    expect(rendered).to match(/No/)
  end
end
