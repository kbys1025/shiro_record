User.create!(name: "管理ユーザー",
              email: "shiro@reco.com",
              password: "000000",
              password_confirmation: "000000",
              admin: true)
              
99.times do |n|
  name = Faker::Name.name
  email = "faker-#{n + 1}@fake.com"
  password = "password"
  User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password)
end
