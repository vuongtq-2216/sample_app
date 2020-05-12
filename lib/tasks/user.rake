namespace :user do
  task :create_users, [:num] => [:environment] do |_, args|
    args[:num].to_i.times do |n|
      name = Faker::Name.name
      email = "example-#{n + 1}@railstutorial.org"
      password = "password"
      User.create!(name: name,
                  email: email,
                  password: password,
                  password_confirmation: password)
    end
  end
end
