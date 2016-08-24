FactoryGirl.define do
    factory :comment do
        body "This is a wonderland"
        user_id { create(:user, :admin).id }

        trait :with_image do
            image { fixture_file_upload("#{::Rails.root}/spec/fixtures/cat.jpg") }
        end

        trait :sequenced_body do
            sequence(:body) { |n| "LE COMMENTS BODDEH#{n}" }
        end
    end
end
