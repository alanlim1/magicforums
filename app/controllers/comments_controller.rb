class CommentsController < ApplicationController
    before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]


    def index
        @post = Post.includes(:comments).find_by(id: params[:post_id])
        @comments = @post.comments.order("created_at DESC")
        @comment = Comment.new
    end

    def new
        @post = Post.find_by(id: params[:id])
        @comment = Comment.new
    end

    def create
        @post = Post.find_by(id: params[:post_id])
        # @comment = Comment.new(comment_params.merge(post_id: params[:post_id]))
        @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))

        if @comment.save
            flash[:success] = "You've created a new comment."
            redirect_to post_comments_path(@post)
        else
            flash[:danger] = @comment.errors.full_messages
            redirect_to new_post_comment_path(@post)
        end
    end

    def edit
        @comment = Comment.find_by(id: params[:id])
        @post = @comment.post
    end

    def update
        @post = Post.find_by(id: params[:post_id])
        @comment = Comment.find_by(id: params[:id])

        if @comment.update(comment_params)      
            redirect_to post_comments_path(@post)
        else
            redirect_to edit_post_comment_path(@post)
        end
    end

    def destroy
        @comment = Comment.find_by(id: params[:id])
        @post = @comment.post

        if @comment.destroy
            redirect_to post_comments_path(@post)
        end
    end


    private

        def comment_params
            params.require(:comment).permit(:body, :image)
        end
end