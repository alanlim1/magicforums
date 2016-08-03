class TopicsController < ApplicationController

	def index
		@topics = Topic.all
	end

	def show
		@topic = Topic.find_by(id: params[:id])
	end

	def new
		@topic = Topic.new
	end

	def create
	end

	def edit
	end

	def update
	end

	def destroy
	end
end