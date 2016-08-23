require 'rails_helper'

RSpec.describe VotesController, type: :controller do
    before(:all) do
        @user = User.create(email:"test@test", password:"test", role: 0)
        @noob = User.create(email:"noob@noob", password:"noob", role: 0)
        @topic = Topic.create(title:"This is title", description:"This is description")
        @post = Post.create(title:"This is post", body:"This is a wonderland", topic_id: @topic.id, user_id: @user.id)
        @comment = Comment.create(body:"This is a comment wonderland", post_id: @post.id, user_id: @user.id)
        @comment2 = Comment.create(body:"This is a comment land 2", post_id: @post.id, user_id: @user.id)


    end

    describe "upvote comment" do
        it "should deny if not logged in" do
            params = { id: @comment.id }
            post :upvote, xhr: true, params: params

            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should create vote if non-existant" do
            params = { comment_id: @comment.id }
            expect(Vote.all.count).to eql(0)
            post :upvote, xhr: true, params: params, session: { id: @user.id }

            expect(Vote.all.count).to eql(1)
            expect(Vote.first.user).to eql(@user)
            expect(Vote.first.comment).to eql(@comment)
            expect(assigns[:vote]).to_not be_nil
        end

        it "should find vote if exists" do
            @vote = @user.votes.create(comment_id: @comment.id)
            expect(Vote.all.count).to eql(1)

            params = { comment_id: @comment.id }
            post :upvote, xhr: true, params: params, session: { id: @user.id }

            expect(Vote.all.count).to eql(1)
            expect(assigns[:vote]).to eql(@vote)
        end

        it "should +1 upvote" do
            @comment = Comment.first
            params = { comment_id: @comment.id }
            post :upvote, xhr: true, params: params, session: { id: @user.id }

            expect(Vote.count).to eql(1)
            expect(flash[:success]).to eql("You upvoted.")
            expect(assigns[:vote].value).to eql(1)
            expect(Vote.first.value).to eql(1)
        end
    end

    describe "downvote comment" do
        it "should deny if not logged in" do
            params = { id: @comment.id }
            post :downvote, xhr: true, params: params

            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should create vote if non-existant" do
            params = { comment_id: @comment.id }
            expect(Vote.all.count).to eql(0)
            post :downvote, xhr: true, params: params, session: { id: @user.id }

            expect(Vote.all.count).to eql(1)
            expect(Vote.first.user).to eql(@user)
            expect(Vote.first.comment).to eql(@comment)
            expect(assigns[:vote]).to_not be_nil
        end

        it "should find vote if it exists" do
            @vote = @user.votes.create(comment_id: @comment.id)
            expect(Vote.all.count).to eql(1)

            params = { comment_id: @comment.id }
            post :downvote, xhr: true, params: params, session: { id: @user.id }

            expect(Vote.all.count).to eql(1)
            expect(assigns[:vote]).to eql(@vote)
        end

        it "should -1 downvote" do
            @comment = Comment.first
            params = { comment_id: @comment.id }
            post :downvote, xhr: true, params: params, session: { id: @user.id }

            expect(Vote.count).to eql(1)
            expect(flash[:danger]).to eql("You downvoted.")
            expect(assigns[:vote].value).to eql(-1)
            expect(Vote.first.value).to eql(-1)
        end
    end
end