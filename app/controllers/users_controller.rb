class UsersController < ApplicationController

    def new
        @user = User.find_by(id: params[:id])
        @user = User.new
    end

    def create
        @user = User.find_by(id: params[:post_id])
        @user = User.new(user_params.merge(user_id: params[:user_id]))

        if @user.save
            flash[:success] = "You've created a new account."
            # redirect_to post_comments_path(@post)
        else
            flash[:danger] = @user.errors.full_messages
            # redirect_to new_post_comment_path(@post)
        end
    end

    def edit
        @user = User.find_by(id: params[:id])
        # @post = @comment.post
    end

    def update
        @user = User.find_by(id: params[:user_id])
        @user = User.find_by(id: params[:id])

        if @user.update(user_params)      
        #     redirect_to post_comments_path(@post)
        # else
        #     redirect_to edit_post_comment_path(@post)
        # end
    end

    private

        def user_params
            params.require(:user).permit(:email, :password_digest, :image, :username)
        end
end