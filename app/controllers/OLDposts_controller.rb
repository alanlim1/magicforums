class PostsController < ApplicationController

	def index
		@posts = Post.all.order(created_at: :desc)
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)

    	if @post.save
      		redirect_to posts_path
    	else
      		render new_post_path
      	end	
    end

	def edit
		@post = Post.find_by(id: params[:id])
	end

	def update
		@post = Post.find_by(id: params[:id])

	    if @post.update(post_params)
	    	redirect_to post_path(@post)
    	else
      		redirect_to edit_post_path(@post)
    	end
	end

	def destroy
		@post = Post.find_by(id: params[:id])
    	
    	if @post.destroy
      		redirect_to posts_path
    	else
      		redirect_to post_path(@post)
    	end
	end


	private

		def post_params
		    params.require(:post).permit(:title, :body)
		end

end	