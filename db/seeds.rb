# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

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
