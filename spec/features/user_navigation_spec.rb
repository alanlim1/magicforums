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

    fill_in('comment_body_field', with: 'new comment')
    click_button('Create Comment')

    find(".fa-thumbs-up").click
    click_button('close-button')

    find(".fa-thumbs-down").click
    click_button('close-button')
    
    click_link('Delete Comment')

    page.driver.browser.switch_to.alert.accept
    # page.accept_alert 'Delete comment?' do
    #   click_button('Yes')
    # end
    #expect(find ("votes-score")).to eql(-1)

    
  end

  # scenario "User logs in, edit and update his/her profile, navigating through various pages" do
  # #(topics, posts, comments index, password forgot page, about page, etc)
  #   visit("http://localhost:3000/sessions/new")
  #   fill_in 'Enter email address', with: 'w@w'
  #   fill_in 'Enter password', with: 'w'
  #   click_button("Press Enter to Login")

  #   click_link("w@w")
  #   fill_in('user_password_field', with: 'w')
  #   click_button("Update Credentials")
  # end

end