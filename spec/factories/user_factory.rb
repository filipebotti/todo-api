FactoryBot.define do
    factory :user do
      name { "John Doe" }
      username  { "john.doe" }
      password { "123456" }
      initialize_with { User.find_or_create_by(username: username) }
    end
  end