class UsersController < ApplicationController
    before_action :authenticate!, only: [:edit, :update, :destroy]

    def new
        # @user = User.find_by(id: params[:id])
        @user = User.new
    end

    def create
        # @user = User.find_by(id: params[:user_id])
        @user = User.new(user_params)
        # (user_params.merge(user_id: params[:user_id]))

        if @user.save
            flash[:success] = "You've created a new account."
        else
            flash[:danger] = @user.errors.full_messages
        end

        redirect_to topics_path
    end

    def edit
        @user = User.find_by(id: params[:id])
        authorize @user
    end

    def update
        @user = User.find_by(id: params[:id])
        authorize @user

        if @user.update(user_params)
            flash[:success] = "You've updated your account."      
            redirect_to topics_path
        else
            flash[:danger] = @user.errors.full_messages
            redirect_to edit_user_path(@user)
        end
    end

    private

        def user_params
            params.require(:user).permit(:email, :password, :image, :username)
        end  
end