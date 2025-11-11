# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

more_users = [
  {:username => 'bbrown1', :password => '1234', first_name: 'B', last_name: 'Brown', email: 'bbrown@email.com', gender: "F", birthdate: '1980-01-01'}
]

more_users.each do |user|
  User.create!(user)
end
