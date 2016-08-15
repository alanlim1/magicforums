postsChannelFunctions = () ->

if $('.comments.index').length > 0
  App.posts_channel = App.cable.subscriptions.create {
    channel: "PostsChannel"
  },
  connected: () ->

  disconnected: () ->

received: (data) ->
setTimeout(
  if $('.comments.index').data().id == data.post.id && $(".comment[data-id=#{data.comment.id}]").length < 1
    $('#comments').append(data.partial)

    if document.hidden
      notification = new Notification data.post.title, body: data.comment.body, icon: data.post.image.thumb.url

      notification.onclick = () ->
        window.focus()
        this.close()
, 100)

$(document).on 'turbolinks:load', postsChannelFunctions
