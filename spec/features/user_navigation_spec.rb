require "rails_helper"

RSpec.feature "User Navigation", type: :feature, js: true do
  before(:all) do
    @user = create(:user)
  end

  scenario "User adds, edits, upvotes, downvotes, and delete comment" do
    visit("http://localhost:3000/topics")
    clink_link("Tree Ranges")
    clink_link("Plenty of Snow")

    fill_in('Description', with: 'Really Long Text…')
    # fill_in 'Enter password', with: 'password'

    click_button('Create Comment')

    user = User.find_by(email: "noob@noob")

    expect(Comment.count).to eql(2)
    expect(user).to be_present
    expect(user.email).to eql("noob@noob")
    # expect(user.username).to eql("ironman")
    expect(find('.flash-messages .message').text).to eql("You've created a new comment.")
    expect(page).to have_current_path(topics_path)
  end
end