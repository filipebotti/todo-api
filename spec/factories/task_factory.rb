require "date"

FactoryBot.define do
    factory :task do
        user
        description { "Task 1" }      
    end

    factory :deleted_task, class: Task do
        user
        description { "Deleted Task" }
        deleted_at { DateTime.now }
    end
end