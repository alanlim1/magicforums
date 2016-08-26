require 'rails_helper'

RSpec.describe Topic, type: :model do
    context "assocation" do
        it { should have_many(:posts) }
    end

    context "topic validation" do
        it { should validate_presence_of(:title) }
        it { should validate_length_of(:title).is_at_least(5) }
        it { should validate_presence_of(:description) }
    end
        

    context "slug callback" do
        it "should set slug" do
            topic = create(:topic)

        expect(topic.title.gsub(" ", "-")).to eql(topic.slug)
        end

        it "should update slug" do
            topic = create(:topic)

            topic.update(title: "updated_title")

            expect(topic.slug).to eql("updated_title")
        end
    end
end