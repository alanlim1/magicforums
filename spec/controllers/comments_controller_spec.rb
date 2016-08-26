require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
    before(:all) do
        @user = create(:user, :sequenced_email)
        @noob = create(:user, email:"noob@noob", password:"noob")
        @topic = create(:topic)
        @post = create(:post, topic_id: @topic.id, user_id: @user.id)
        @comment = create(:comment, post_id: @post.id, user_id: @user.id)
        @comment2 = create(:comment, post_id: @post.id, user_id: @user.id)
    
    end

    describe "index comments" do
        it "should render comments index" do
            params = { post_id: @post.id }
            get :index, params: params

            expect(assigns[:comments].count).to eql(2)
            expect(subject).to render_template(:index)
        end
    end

    describe "create comment" do
        it "should deny if not logged in" do
            params = { post_id: @post.id, comment: { body: "YBIAW Wonderland 2" } }
            post :create, xhr: true, params: params

            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should create new comment" do
            params = { post_id: @post.id, comment: { body: "A Wonderland 3" } }
            post :create, xhr: true, params: params, session: { id: @user.id }

            comment = Comment.find_by(body: "A Wonderland 3")

            expect(Comment.count).to eql(3)
            expect(comment).to be_present
            expect(comment.body).to eql("A Wonderland 3")
        end
    end

    describe "edit comment" do
        it "should redirect if not logged in" do
            @comment = Comment.first
            params = { id: @comment.id, post_id: @post.id }
            get :edit, xhr: true, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            @comment = Comment.first
            params = { comment: @comment.id, post_id: @post.id, id: @user.id }
            get :edit, params: params, session: { id: @noob.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render edit" do
            @comment = Comment.first
            params = { post_id: @post.id, comment: @comment.id, id: @user.id }
            get :edit, xhr: true, params: params, session: { id: @user.id }

            current_user = subject.send(:current_user)
            expect(subject).to render_template(:edit)
            expect(current_user).to be_present
        end
    end

    describe "update post" do
        it "should redirect if not logged in" do
            params = { post_id: @post.slug, id: @comment.id } 
            patch :update, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            params = { comment_id: @comment.id, post_id: @post.id, id: @user.id, comment: { body: "NEW BOD YO" } }
            patch :update, xhr: true, params: params, session: { id: @noob.id }

            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should update post for user post" do
            @comment = Comment.first
            params = { id: @comment.id, post_id: @post.id, comment: { body: "NEW BOD YO" } }
            patch :update, xhr: true, params: params, session: { id: @user.id }

            @comment.reload
            expect(@comment.body).to eql("NEW BOD YO")
            expect(flash[:success]).to eql("Comment updated!")
        end
    end

    describe "destroy post" do
        it "should redirect if not logged in" do
            @comment = Comment.first
            params = { post_id: @post.id, comment: @comment.id, id:@user.id }
            delete :destroy, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            @comment = Comment.first
            params = { post_id: @post.id, comment: @comment.id, id:@user.id }
            delete :destroy, params: params, session: { id: @noob.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render destroy post" do
            @comment = Comment.first
            params = { post_id: @post.id, comment: @comment.id, id: @user.id }
            delete :destroy, xhr: true, params: params, session: { id: @user.id }

            comment = Comment.find_by(id: @comment.id)

            expect(@user.comments.count).to eql(1)
            expect(comment).to be_nil
        end
    end

end