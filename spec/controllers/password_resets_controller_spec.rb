require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
    before(:all) do
        @user = User.create(email:"test@test", password:"test", role: 0)
        @noob = User.create(email:"noob@noob", password:"noob", role: 0)
    end

    describe "new pw reset" do
        it "should render new" do
            get :new
            expect(subject).to render_template(:new)
        end
    end

    describe "create pw reset" do
        it "should render create" do
            get :new
            expect(subject).to render_template(:new)
        end

        it "should email instructions to user for pw reset" do
            email = @user.email
            params = { reset: { email: email} }
            post :create, params: params

            @user.reload

            expect(flash[:success]).to eql("We've sent you instructions on how to reset your password")
            expect(ActionMailer::Base.deliveries.count).to eql(1)
            expect(@user.password_reset_token).to be_present
            expect(@user.password_reset_at).to be_present
            expect(subject).to redirect_to(new_password_reset_path)
        end

        it "should give error flash message if email non-existant" do
            params = { reset: { email: "fake@fake" } }
            post :create, params: params

            @user.reload

            expect(@user.password_reset_token).to be_nil
            expect(@user.password_reset_at).to be_nil
            expect(flash[:danger]).to eql("User does not exist")
            expect(subject).to redirect_to(new_password_reset_path)
        end
    end

    describe "edit pw reset" do
        it "should render edit" do
            params = { id: @user.id }
            get :edit, params: params
            expect(subject).to render_template(:edit)
        end
    end

    describe "update" do
        it "should update" do
            @user.update(password_reset_token: "token", password_reset_at: DateTime.now)
            params = { id: @user.password_reset_token, user: {password: "newpass"}}
            patch :update, params: params

            @user.reload

            @oldpw = @user.authenticate("testo")
            @userx = @user.authenticate("newpass")

            expect(@oldpw).to eql(false)
            expect(@user).to be_present
            expect(flash[:success]).to eql("Password updated, you may log in now")
            expect(subject).to redirect_to(root_path)
        end
    end
    # requires token in link from email

    # describe "update pw reset" do
    #     it "should update pw" do
    #         patch :update

    #     @user = User.find_by(password_reset_token: params[:id])

    #     if @user && token_active?
    #     expect(subject).to redirect_to(root_path)
    #     expect flash message
    #     expect pw updated


    #     if token inactive
    #         expect redirect to
    #         expect DANGER flash msg

    #     end
    # end


    # describe "update password" do

    #     it "should update user password" do

    #         params = { reset: { email: "user@user" } }
    #         post :create, params: params

    #         @user.reload

    #         params = { id: @user.password_reset_token, user: { password: "newpassword" } }
    #         patch :update, params: params

    #         @user.reload

    #         user = @user.authenticate("newpassword")

    #         expect(user).to be_present
    #         expect(user.password_reset_token).to be_nil
    #         expect(user.password_reset_at).to be_nil
    #         expect(subject).to redirect_to(root_path)
    #     end

    #     it "should err if token invalid" do

    #         params = { reset: { email: "user@email.com" } }
    #         post :create, params: params

    #         edit_params = { id: "wrongtoken" }
    #         params = { id: "wrongtoken", user: { password: "newpassword" } }
    #         patch :update, params: params

    #         @user.reload

    #         user = @user.authenticate("newpassword")

    #         expect(user).to eql(false)
    #         expect(flash[:danger]).to eql("Error, token is invalid or has expired")
    #         expect(subject).to redirect_to(edit_password_reset_path(edit_params))
    #     end
    # end
end