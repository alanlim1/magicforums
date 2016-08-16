postsChannelFunctions = () ->

  checkMe = (comment_id, user_email) ->
    unless $('meta[name=admin]').length > 0 || $("meta[user=#{user_email}]").length > 0
      $(".comment[data-id=#{comment_id}] .control-panel").remove()
    $(".comment[data-id=#{comment_id}]").removeClass("")

  if $('.comments-main').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->

    disconnected: () ->

    received: (data) ->
      if $('.comments-main').data().id == data.post.id
        $('#comments-form-container').append(data.partial)
        checkMe(data.comment.id)

$(document).on 'turbolinks:load', postsChannelFunctions