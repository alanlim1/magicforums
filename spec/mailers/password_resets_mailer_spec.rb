require 'rails_helper'

describe PasswordResetsMailer do
  before(:all) do
    @user = User.create(email:"test@test", password:"test", role: 0)
    @noob = User.create(email:"test2@test2", password:"test2", role: 0)
  end

  describe "should send email" do
    it "should send email with link to reset password" do

      @noob.update(password_reset_token: "resettoeken", password_reset_at: DateTime.now)
      mail = PasswordResetsMailer.password_reset_mail(@noob)

      expect(mail.to[0]).to eql(@noob.email)
      expect(mail.body.include?("#{ENV.fetch('SERVER_URL')}/password_resets/resettoeken/edit")).to eql(true)
    end
  end
end