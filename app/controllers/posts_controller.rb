class PostsController < ApplicationController
    respond_to :js
    before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]


    def index
        @topic = Topic.includes(:posts).friendly.find(params[:id])
        @posts = @topic.posts.order("created_at DESC").page params[:page]
        @post = Post.new
    end

    def new
        @topic = Topic.friendly.find(params[:id])
        @post = Post.new
    end

    def create
        @topic = Topic.friendly.find(params[:id])
        @post = current_user.posts.build(post_params.merge(topic_id: params[:id]))
        @new_post = Post.new
        
        if @post.save
            flash.now[:success] = "You've created a new post."
        else
            flash.now[:danger] = @post.errors.full_messages
        end
    end

    def edit
        @post = Post.find_by(id: params[:id])
        @topic = @post.topic
        authorize @post
    end

    def update
        @topic = Topic.find_by(id: params[:topic_id])
        @post = Post.find_by(id: params[:id])

        if @post.update(post_params)  
            flash.now[:success] = "You've updated your post."    
        else
        	flash.now[:danger] = @post.errors.full_messages
        end
    end

    def destroy
        @post = Post.find_by(id: params[:id])
        @topic = @post.topic
        authorize @post

        if @post.destroy
        	flash.now[:danger] = "Post deleted!"
        end
    end


    private

        def post_params
            params.require(:post).permit(:title, :body, :image)
        end
end