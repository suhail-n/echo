class WorkoutPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout_plan, only: %i[ show edit update destroy ]
  # GET /workout_plans or /workout_plans.json
  def index
    @workout_plans = current_user.workout_plans.order(:created_at)
  end

  # GET /workout_plans/1 or /workout_plans/1.json
  def show
  end

  # GET /workout_plans/new
  def new
    @workout_plan = WorkoutPlan.new
  end

  def add_workout_day
    @workout_day = @workout_plan.workout_days.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("workout_days", partial: "workout_days/form", locals: { workout_day: @workout_day })
      end
    end
  end

  # GET /workout_plans/1/edit
  def edit
  end

  # POST /workout_plans or /workout_plans.json
  def create
    @workout_plan = current_user.workout_plans.build(workout_plan_params)

    respond_to do |format|
      if @workout_plan.save
        format.html { redirect_to @workout_plan, notice: "Workout plan was successfully created." }
        format.json { render :show, status: :created, location: @workout_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @workout_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workout_plans/1 or /workout_plans/1.json
  def update
    respond_to do |format|
      if @workout_plan.update(workout_plan_params)
        format.html { redirect_to @workout_plan, notice: "Workout plan was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @workout_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @workout_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workout_plans/1 or /workout_plans/1.json
  def destroy
    @workout_plan.destroy!

    respond_to do |format|
      format.html { redirect_to workout_plans_path, notice: "Workout plan was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workout_plan
      @workout_plan = current_user.workout_plans.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def workout_plan_params
      params.expect(workout_plan: [ :name, :is_template, :is_published ])
    end
end
