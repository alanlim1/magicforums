FactoryGirl.define do
    factory :post do
        title "This is post"
        body "This is a wonderland"
        user_id { create(:user, :admin).id }

        trait :with_image do
            image { fixture_file_upload("#{::Rails.root}/spec/fixtures/cat.jpg") }
        end

        trait :sequenced_title do
            sequence(:title) { |n| "This is a pasta post#{n}" }
        end

        trait :sequenced_body do
            sequence(:body) { |n| "LE VANDALAND#{n}" }
        end
    end
end
