User.create!(name: "サンプル1",
              email: "shiro@reco.com",
              password: "000000",
              password_confirmation: "000000",
              admin: true)

User.create!(name: "サンプル2",
              email: "shiro2@reco.com",
              password: "000000",
              password_confirmation: "000000" )

99.times do |n|
  name = Faker::Name.name
  email = "faker-#{n + 1}@fake.com"
  password = "password"
  User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password)
end
