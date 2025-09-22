# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "csv"

admin = User.find_or_initialize_by(email: 'admin@example.com')
admin.password = 'password'
admin.password_confirmation = 'password'
# If Devise confirmable is enabled, mark the admin as confirmed so they can sign in
if admin.respond_to?(:confirmed_at)
  admin.confirmed_at ||= Time.current
end
admin.save! if admin.changed?

WorkoutPlan.find_or_create_by(name: 'Full Body Workout', user: admin)
WorkoutPlan.find_or_create_by(name: 'PPL', user: admin)

# generate list of muscle groups if they don't already exist
muscle_groups = [ "Chest", "Upper back", "Abs", "Traps", "Front delts", "Rear delts", "Side delts", "Lats", "Upper back", "Triceps", "Biceps", "Forearms", "Lower back", "Abductors", "Adductors", "Glutes", "Hamstrings", "Quadriceps", "Calves" ]
muscle_groups.each do |muscle_group|
  Muscle.find_or_create_by!(name: muscle_group)
end

# load exercises and their muscle mappings from the preprocessed CSV file
csv_path = Rails.root.join('data', 'gym_exercise_dataset_grouped.csv').to_s
if File.exist?(csv_path)
  unmapped_muscles = Hash.new { |h, k| h[k] = [] }
  CSV.foreach(csv_path, headers: true) do |row|
    exercise_name = row['Exercise Name']
    primary_muscle_name = row['primary_muscle']
    next if primary_muscle_name.nil? || primary_muscle_name.strip == '' || primary_muscle_name == 'N/A'

    secondary_muscle_field = row['secondary_muscle']
    secondary_names = (secondary_muscle_field || '').split('|').map(&:strip).reject(&:empty?)

    exercise = Exercise.find_or_create_by!(name: exercise_name)

    # Primary muscle
    primary_muscle = Muscle.find_by(name: primary_muscle_name)
    unless primary_muscle
      unmapped_muscles[exercise_name] << primary_muscle_name
    else
      ExerciseMuscle.find_or_create_by!(exercise: exercise, muscle: primary_muscle, role: "primary")
    end

    # Secondary muscles - skip any that match primary
    secondary_names.each do |sec_name|
      next if sec_name == primary_muscle_name
      muscle = Muscle.find_by(name: sec_name)
      unless muscle
        unmapped_muscles[exercise_name] << sec_name
        next
      end
      ExerciseMuscle.find_or_create_by!(exercise: exercise, muscle: muscle, role: "secondary")
    end
  end

  if unmapped_muscles.any?
    puts "The following exercises referenced muscles that don't exist in the muscle list:\n"
    unmapped_muscles.each do |exercise_name, muscles|
      puts "#{exercise_name}: #{muscles.uniq.join(', ')}"
    end
  end
end
