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
    end

    # needs to be logged in
    # needs token
    # expects flash message x2 if accept or DANGER
    # expect redirect

    describe "edit pw reset" do
        it "should render edit" do
            get :edit
            expect(subject).to render_template(:edit)
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


















end