postsChannelFunctions = () ->

  checkMe = (post_id, user_email) ->
    unless $('meta[name=admin]').length > 0 || $("meta[user=#{user.email}]").length > 0
      $(".post[data-id=#{post_id}] .control-panel").remove()

  createPost = (data) ->
    if $('.posts-main').data().id == data.topic.id
      $('#posts-form-container').append(data.partial)
      checkMe(data.post.id)

  updatePost = (data) ->
    if $('.posts-main').data().id == data.topic.id
      $(".post[data-id=#{data.post.id}]").replaceWith(data.partial)
      checkMe(data.post.id, data.user_email)

  destroyPost = (data) ->
    if $('.posts-main').data().id == data.topic.id
      $(".post[data-id=#{data.post.id}]").remove();

  if $('.posts-main').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->

    disconnected: () ->

    received: (data) ->
      switch data.type
        when "create" then createPost(data)
        when "update" then updatePost(data)
        when "destroy" then destroyPost(data)

$(document).on 'turbolinks:load', postsChannelFunctions