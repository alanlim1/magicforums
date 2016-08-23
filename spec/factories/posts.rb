FactoryGirl.define do
    factory :post do
        title "This is post"
        body "This is a wonderland"
        user_id { create(:user, :admin).id }

        trait :with_image do
            image { fixture_file_upload("#{::Rails.root}/spec/fixtures/cat.jpg") }
        end

        trait :sequenced_title do
            title
        end

        trait :sequenced_body do
            body
        end
    end
end
