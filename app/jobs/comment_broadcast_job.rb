class CommentBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment, user)
    ActionCable.server.broadcast 'posts_channel', comment: comment, post: comment.post, partial: render_comment_partial(comment, user)
  end

  private

  def render_comment_partial(comment, user)
    CommentsController.render partial: "comments/comment", locals: { comment: comment, post: comment.post, current_user: user }
  end
end