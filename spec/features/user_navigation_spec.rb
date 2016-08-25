require "rails_helper"

RSpec.feature "User Navigation", type: :feature, js: true do
  before(:all) do
    @user = create(:user)
  end

  scenario "User adds, edits, upvotes, downvotes, and delete comment" do
    visit("http://localhost:3000/sessions/new")
    fill_in 'Enter email address', with: 'w@w'
    fill_in 'Enter password', with: 'w'
    click_button("Press Enter to Login")
    click_link("Tree Ranges")
    click_link("Plenty of Snow")

    fill_in('comment_body_field', with: 'Really Long Text…')
    # fill_in 'Enter password', with: 'password'

    click_button('Create Comment')

    find(".fa-thumbs-up").click
    find(".fa-thumbs-down").click
    click_link('Delete Comment')
    # click_link("Logout")
  end

  # scenario "User logs in, edit and update his/her profile, navigating through various pages"
  # #(topics, posts, comments index, password forgot page, about page, etc)
  #   visit("http://localhost:3000/sessions/new")
  #   fill_in 'Enter email address', with: 'w@w'
  #   fill_in 'Enter password', with: 'w'

  #   click_link("current_user.email")
  #   fill_in('user_password_field', with: 'www')
  #   click_button("Update Credentials")
end