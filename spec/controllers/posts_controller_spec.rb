require 'rails_helper'

RSpec.describe PostsController, type: :controller do
    before(:all) do
        @user = User.create(email:"test@test", password:"test")
        Topic.create(title:"This is title", description:"This is description")
        Post.create(title:"This is post", body:"This is a wonderland")
    end

    describe "index posts" do
        it "should render post index" do
            get :index, params: nil

            expect(assigns[:posts].count).to eql(1)
            expect(subject).to render_template(:index)
        end
    end

    describe "new post" do
        it "should deny if not logged in" do
            get :new, params: nil
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should render new" do
            get :new, params: nil, session: { id: @user.id }

            expect(assigns[:post]).to be_present
            expect(subject).to render_template(:new)
        end
    end

    describe "create post" do
        it "should deny if not logged in" do
            params = { post: { title: "New Post 2", body: "Your body is a wonderland 2" } }
            post :create, params: params

            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should create new post" do
            params = { post: { title: "Post 3", body: "A Wonderland 3" } }
            post :create, params: params, session: { id: @user.id }

            post = Post.find_by(title: "Post 3")

            expect(Topic.count).to eql(2)
            expect(topic).to be_present
            expect(topic.description).to eql("Post 3")
            expect(subject).to redirect_to(topic_posts_path)
        end
    end

    describe "edit topic" do
        it "should redirect if not logged in" do
            params = { id: @user.id }
            get :edit, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            params = { id: @user.id }
            get :edit, params: params, session: { id: @user.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render edit" do
            params = { id: @user.id }
            get :edit, params: params, session: { id: @user.id }

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
            params = { id: @user.id }
            get :destroy, params: params, session: { id: @user.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render destroy" do
            params = { id: @user.id }
            get :destroy, params: params, session: { id: @user.id }

            current_user = subject.send(:current_user)
            expect(subject).to redirect_to(root_path)
            expect(current_user).to be_present
        end
    end

end