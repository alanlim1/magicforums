require 'rails_helper'

RSpec.describe PostsController, type: :controller do
    before(:all) do
        @user = create(:user)
        @noob = create(:user, email:"noob@noob", password:"noob")
        @topic = create(:topic)
        @post = create(:post, title:"This is post", body:"This is a wonderland", topic_id: @topic.id, user_id: @user.id)
        @post2 = create(:post, title:"This is post2", body:"This is a wonderland2", topic_id: @topic.id, user_id: @user.id)
    
    end

    describe "index posts" do
        it "should render post index" do
            params = { topic_id: @topic.id }
            get :index, params: params

            expect(assigns[:posts].count).to eql(2)
            expect(subject).to render_template(:index)
        end
    end

    describe "new post" do
        it "should deny if not logged in" do
            get :new, xhr: true, params: { topic_id: @topic.id }

            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should render new" do
            params = { topic_id: @topic.id }
            get :new, xhr: true, params: params, session: { id: @user.id }

            expect(assigns[:post]).to be_present
        end
    end

    describe "create post" do
        it "should deny if not logged in" do
            params = { topic_id: @topic.id, post: { title: "New Post 2", body: "YBIAW Wonderland 2" } }
            post :create, xhr: true, params: params

            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should create new post" do
            params = { topic_id: @topic.id, post: { title: "Post 3", body: "A Wonderland 3" } }
            post :create, xhr: true, params: params, session: { id: @user.id }

            post = Post.find_by(title: "Post 3")

            expect(Post.count).to eql(3)
            expect(post).to be_present
            expect(post.title).to eql("Post 3")
            expect(post.body).to eql("A Wonderland 3")
        end
    end

    describe "edit post" do
        it "should redirect if not logged in" do
            @post = Post.first
            params = { topic_id: @topic.id, id: @post.id }
            get :edit, xhr: true, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            @post = Post.first
            params = { topic_id: @topic.id, post: @post.id, id: @user.id }
            get :edit, params: params, session: { id: @noob.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render edit" do
            @post = Post.first
            params = { topic_id: @topic.id, post: @post.id, id: @user.id }
            get :edit, xhr: true, params: params, session: { id: @user.id }

            current_user = subject.send(:current_user)
            expect(subject).to render_template(:edit)
            expect(current_user).to be_present
        end
    end

    describe "update post" do
        it "should redirect if not logged in" do
            params = { id: @topic.slug } 
            patch :update, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            params = { topic_id: @topic.id, post_id: @post.id, id: @user.id, post: { title: "NEW POST YO", body: "NEW BOD YO" } }
            patch :update, xhr: true, params: params, session: { id: @noob.id }

            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should update post for user post" do
            @post = Post.first
            params = { topic_id: @topic.id, id: @post.id, post: { title: "NEW POST YO", body: "NEW BOD YO" } }
            patch :update, xhr: true, params: params, session: { id: @user.id }

            @post.reload
            expect(@post.title).to eql("NEW POST YO")
            expect(@post.body).to eql("NEW BOD YO")
            expect(flash[:success]).to eql("You've updated your post.")
        end
    end

    describe "destroy post" do
        it "should redirect if not logged in" do
            @post = Post.first
            params = { topic_id: @topic.id, post: @post.id, id:@user.id }
            delete :destroy, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            @post = Post.first
            params = { topic_id: @topic.id, post: @post.id, id:@user.id }
            delete :destroy, params: params, session: { id: @noob.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render destroy post" do
            @post = Post.first
            params = { topic_id: @topic.id, post: @post.id, id: @user.id }
            delete :destroy, xhr: true, params: params, session: { id: @user.id }

            post = Post.find_by(id: @post.id)

            expect(@user.posts.count).to eql(1)
            expect(post).to be_nil
        end
    end

end