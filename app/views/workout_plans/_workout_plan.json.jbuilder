json.extract! workout_plan, :id, :name, :user_id, :is_template, :is_published, :created_at, :updated_at
json.url workout_plan_url(workout_plan, format: :json)
