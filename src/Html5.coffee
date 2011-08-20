class Html5Video

  constructor: (@presentz) ->
    @video = new Video "play", "pause", "ended", @presentz

  changeVideo: (videoData, play) ->
    if $("#videoContainer").children().length == 0
      videoHtml = "<video controls preload='none' src='#{ videoData.url }' width='100%' heigth='100%'></video>"
      $("#videoContainer").append(videoHtml)

      caller = this
      eventHandler = `function(event) {
        caller.video.handleEvent(event.type);
      }`
      video = $("#videoContainer > video")[0]
      video.onplay = eventHandler
      video.onpause = eventHandler
      video.onended = eventHandler
    else
      video = $("#videoContainer > video")[0]
      video.setAttribute("src", videoData.url)

    video.load()

    if play
    	if not @presentz.intervalSet
    		@presentz.startTimeChecker()
    		
    	video.play()

    return

  currentTime: () ->
    return $("#videoContainer > video")[0].currentTime