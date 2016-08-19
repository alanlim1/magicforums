class PostBroadcastJob < ApplicationJob
    queue_as :default

    def perform(type, post)
        ActionCable.server.broadcast 'posts_channel', type: type, post: post, topic: post.topic, email: post.user.email, partial: render_post_partial(post)
    end

    private

    def render_post_partial(post)
        PostsController.render partial: "posts/post", locals: { post: post, topic: post.topic, current_user: post.user }
    end
end
