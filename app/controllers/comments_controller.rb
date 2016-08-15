class CommentsController < ApplicationController
    respond_to :js
    before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]
    # before_action :authenticate!, except: [:index]

    def index
        @post = Post.includes(:comments).find_by(id: params[:post_id])
        @comments = @post.comments.order("created_at DESC").page params[:page]
        @comment = Comment.new
    end

    def create
        @post = Post.find_by(id: params[:post_id])
        @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))
        @new_comment = Comment.new

        if @comment.save
            flash.now[:success] = "You've created a new comment."
        else
            flash.now[:danger] = @comment.errors.full_messages
        end
    end

    def edit
        @comment = Comment.find_by(id: params[:id])
        @post = @comment.post
        authorize @comment
    end

    def update
        @post = Post.find_by(id: params[:post_id])
        @comment = Comment.find_by(id: params[:id])

        if @comment.update(comment_params)    
            flash[:success] = "Comment updated!"  
            redirect_to post_comments_path(@post)
        else
            flash[:danger] = @comment.errors.full_messages
            redirect_to edit_post_comment_path(@post)
        end
    end

    def destroy
        @comment = Comment.find_by(id: params[:id])
        @post = @comment.post
        authorize @comment

        if @comment.destroy
            flash[:danger] = "Comment deleted!"
            redirect_to post_comments_path(@post)
        end
    end


    private

        def comment_params
            params.require(:comment).permit(:body, :image)
        end
end