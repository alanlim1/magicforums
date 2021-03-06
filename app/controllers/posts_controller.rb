class PostsController < ApplicationController
    respond_to :js
    before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]


    def index
        @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
        @posts = @topic.posts.order("created_at DESC").page params[:page]
        @post = Post.new
    end

    def new
        @topic = Topic.friendly.find(params[:topic_id])
        @post = Post.new
    end

    def create
        @topic = Topic.friendly.find(params[:topic_id])
        @post = current_user.posts.build(post_params.merge(topic_id: @topic.id))
        @new_post = Post.new
        
        if @post.save
            PostBroadcastJob.perform_later("create", @post)
            flash.now[:success] = "You've created a new post."
        else
            flash.now[:danger] = @post.errors.full_messages
        end
    end

    def edit
        @post = Post.friendly.find(params[:id])
        @topic = Topic.friendly.find(params[:topic_id])
        authorize @post
    end

    def update
        @topic = Topic.friendly.find(params[:topic_id])
        @post = Post.friendly.find(params[:id])
        authorize @post

        if @post.update(post_params)
            PostBroadcastJob.perform_later("update", @post)    
            flash.now[:success] = "You've updated your post." 
        else
        	flash.now[:danger] = @post.errors.full_messages
        end
    end

    def destroy
        @post = Post.friendly.find(params[:id])
        authorize @post

        if @post.destroy
            PostBroadcastJob.perform_now("destroy", @post)
        	flash.now[:danger] = "Post deleted!"
        end
    end


    private

        def post_params
            params.require(:post).permit(:title, :body, :image)
        end
end