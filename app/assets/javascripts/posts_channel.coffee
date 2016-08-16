postsChannelFunctions = () ->

  checkMe = (comment_id, username) ->
    unless $('meta[name=admin]').length > 0 || $("meta[user=#{username}]").length > 0
      $("<your-comment-element-name>[data-id=#{comment_id}] .<your-buttons-container-element>").remove()
    $("<your-comment-element-name>[data-id=#{comment_id}]").removeClass("hidden")

  if $('<your-comments-index-element>').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->

    disconnected: () ->

    received: (data) ->
      if $('<your-comments-index-element>').data().id == data.post.id
        $('<your-comments-container>').append(data.partial)
        checkMe(data.comment.id)

$(document).on 'turbolinks:load', postsChannelFunctions