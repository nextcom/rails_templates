Sham.username { Faker::Internet.user_name }
Sham.email { Faker::Internet.email }
Sham.password(:unique => false) { "testpassword" }

User.blueprint do
  username
  email
  password
  password_confirmation { self.password }
end

User.blueprint(:admin) do
  username { Sham.username + "_admin" }
  admin { true }
end