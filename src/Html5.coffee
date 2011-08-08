class Html5Video extends Video

  constructor: (presentz) ->
    super "play", "pause", "ended", presentz

  changeVideo: (videoData, play) ->
    if $("#videoContainer").children().length == 0
      videoHtml = "<video controls preload='none' src='#{ videoData.url }' width='100%' heigth='100%'></video>"
      $("#videoContainer").append(videoHtml)

      video = $("#videoContainer > video")[0]
      video.addEventListener("play", @handleEvent, false)
      video.addEventListener("pause", @handleEvent, false)
      video.addEventListener("ended", @handleEvent, false)
    else
      video = $("#videoContainer > video")[0]
      video.setAttribute("src", videoData.url)

  handleEvent: (event) ->
    super event.type