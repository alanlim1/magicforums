FactoryGirl.define do
    factory :topic do
        title "Topic"
        description "Topic Description"
        user_id { create(:user, :admin).id }

        trait :sequenced_title do
            sequence(:title) { |n| "Topic#{n}" }
        end

        trait :sequenced_description do
            sequence(:description) { |n| "Description#{n}" }
        end
    end
end
