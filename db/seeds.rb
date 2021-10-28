99.times do |i|
  User.create!(name: Faker::Name.name,
              email: "user.#{i}@mysampleapp.com",
              password: "12345678",
              password_confirmation: "12345678")
end
User.create!(name: "bloomingseed",
            email: "bloomingseed@mysampleapp.com",
            password: "12345678",
            password_confirmation: "12345678",
            is_admin: true)
