commentsChannelFunctions = () ->

  checkMe = (comment_id, user_email) ->
    unless $('meta[name=admin]').length > 0 || $("meta[user=#{user_email}]").length > 0
      $(".comment[data-id=#{comment_id}] .control-panel").remove()

  createComment = (data) ->
    if $('.comments-main').data().id == data.post.id
      $('#comments-form-container').append(data.partial)
      checkMe(data.comment.id)

  updateComment = (data) ->
    if $('.comments-main').data().id == data.post.id
      $(".comment[data-id=#{data.comment.id}]").replaceWith(data.partial)
      checkMe(data.comment.id, data.user_email)

  destroyComment = (data) ->
    if $('.comments-main').data().id == data.post.id
      $(".comment[data-id=#{data.comment.id}]").remove();

  if $('.comments-main').length > 0
    App.comments_channel = App.cable.subscriptions.create {
      channel: "CommentsChannel"
    },
    connected: () ->

    disconnected: () ->

    received: (data) ->
      switch data.type
        when "create" then createComment(data)
        when "update" then updateComment(data)
        when "destroy" then destroyComment(data)

$(document).on 'turbolinks:load', commentsChannelFunctions