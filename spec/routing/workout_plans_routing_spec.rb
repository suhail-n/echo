require "rails_helper"

RSpec.describe WorkoutPlansController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/workout_plans").to route_to("workout_plans#index")
    end

    it "routes to #new" do
      expect(get: "/workout_plans/new").to route_to("workout_plans#new")
    end

    it "routes to #show" do
      expect(get: "/workout_plans/1").to route_to("workout_plans#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/workout_plans/1/edit").to route_to("workout_plans#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/workout_plans").to route_to("workout_plans#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/workout_plans/1").to route_to("workout_plans#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/workout_plans/1").to route_to("workout_plans#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/workout_plans/1").to route_to("workout_plans#destroy", id: "1")
    end
  end
end
