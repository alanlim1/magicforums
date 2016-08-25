require "rails_helper"

RSpec.feature "User Creation", type: :feature do
  before(:all) do
    @user = create(:user)
  end

  scenario "User registers" do

    visit new_user_path
    # fill_in 'Username', with: 'ironman'
    fill_in 'Enter email address', with: 'noob@noob'
    fill_in 'Enter password', with: 'password'

    click_button('Create User')

    user = User.find_by(email: "noob@noob")

    expect(User.count).to eql(2)
    expect(user).to be_present
    expect(user.email).to eql("noob@noob")
    # expect(user.username).to eql("ironman")
    expect(find('.flash-messages .message').text).to eql("You've created a new account.")
    expect(page).to have_current_path(topics_path)
  end
end