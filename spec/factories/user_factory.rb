FactoryBot.define do
    factory :user do
      name { "John Doe" }
      username  { "john.doe" }
      password { "123456" }
    end
  end