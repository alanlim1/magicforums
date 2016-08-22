require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
    before(:all) do
        @admin = User.create(email:"hax@hax", password:"hax", role: 2)
        @user = User.create(email:"test@test", password:"test")
        Topic.create(title:"This is title", description:"This is description")
    end

    describe "index topics" do
        it "should render index topics" do
            get :index
            expect(assigns[:topics].count).to eql(1)
            expect(subject).to render_template(:index)
        end
    end

    describe "new topic" do
        it "should deny if not logged in" do
            get :new, params: nil
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should render new for admin" do
            get :new, params: nil, session: { id: @admin.id }
            expect(subject).to render_template(:new)
        end

        it "should deny user" do
            cookies.signed[:id] = @user.id
            get :new, params: nil
            expect(flash[:danger]).to eql("You need to login first")
        end
    end

    describe "create topic" do
        it "should deny if not logged in" do
            params = { topic: { title: "New Title Nu", description: "New Description Nu" } }
            post :create, params: params

            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should create new topic for admin" do
            params = { topic: { title: "New Title", description: "New Description" } }
            post :create, params: params, session: { id: @admin.id }

            topic = Topic.find_by(title: "New Title")

            expect(Topic.count).to eql(2)
            expect(topic).to be_present
            expect(topic.description).to eql("New Description")
            expect(subject).to redirect_to(topics_path)
        end

        # it "should deny if user not admin" do
        #     params = { topic: { title: "New Title", description: "New Description" } }
        #     post :create, params: params, session: { id: @user.id }

        #     expect(flash[:danger]).to eql("You are not authorized")
        # end
    end

    describe "edit topic" do
        it "should redirect if not logged in" do
            params = { id: @user.id }
            get :edit, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            params = { id: @admin.id }
            get :edit, params: params, session: { id: @user.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render edit" do
            params = { id: @admin.id }
            get :edit, params: params, session: { id: @admin.id }

            current_user = subject.send(:current_user)
            expect(subject).to render_template(:edit)
            expect(current_user).to be_present
        end
    end

    describe "destroy topic" do
        it "should redirect if not logged in" do
            params = { id: @user.id }
            get :destroy, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            params = { id: @admin.id }
            get :destroy, params: params, session: { id: @user.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render destroy" do
            params = { id: @admin.id }
            get :destroy, params: params, session: { id: @admin.id }

            current_user = subject.send(:current_user)
            expect(subject).to redirect_to(topics_path)
            expect(current_user).to be_present
        end
    end

end