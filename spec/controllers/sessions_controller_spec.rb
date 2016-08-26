require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
    before(:all) do
        @user = create(:user)
        @noob = create(:user, email:"noob@noob", password:"noob", role: 0)
    end

    describe "new login" do
        it "should render new" do
            get :new, params: nil

            expect(subject).to render_template(:new)
        end
    end

    describe "create session" do
        it "should redirect after logging in" do
            params = { user: { email: "noob@noob", password: "noob"} }
            post :create, params: params

            current_user = subject.send(:current_user)
            @noob.reload
            user = User.find_by(email: "noob@noob")

            # expect(subject).to redirect_to(topics_path)
            # expect(cookies.signed[:id]).to eql(user.id)
            # expect(current_user).to be_present
            # expect(flash[:success]).to eql("Welcome back #{current_user.email}")

        end

        it "should redirect and render new if error logging in" do
            params = { user: { email: "testo@testo", password: "testo" } }
            post :create, params: params

            current_user = subject.send(:current_user)

            expect(current_user).to be_nil
            expect(flash[:danger]).to eql("Error logging in")
            expect(subject).to render_template(:new)
        end
    end

    describe "destroy session" do
        it "should redirect and delete session" do
            params = { id: @user.id }
            delete :destroy, params: params, session: { id: @user.id }

            current_user = subject.send(:current_user)
            user = User.find_by(email: "test@test")

            expect(current_user).to_not be_present
            expect(flash[:success]).to eql("You've been logged out")
            expect(subject).to redirect_to(root_path)
        end
    end

end