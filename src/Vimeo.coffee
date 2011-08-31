class Vimeo

  constructor: (@presentz) ->
    @video = new Video "play", "pause", "finish", @presentz
    @wouldPlay = false
    @currentTimeInSeconds = 0.0

  changeVideo: (@videoData, @wouldPlay) ->
    ajaxCall =
      url: "http://vimeo.com/api/v2/video/#{ videoId(@videoData) }.json"
      dataType: "jsonp"
      jsonpCallback: "presentz.videoPlugin.receiveVideoInfo"

    $.ajax ajaxCall
    return

  videoId = (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  receiveVideoInfo: (data) ->
    movieUrl = "http://player.vimeo.com/video/#{ videoId(@videoData) }?api=1&player_id=vimeoPlayer"

    if $("#videoContainer").children().length == 0
      width = $("#videoContainer").width()
      height = (width / data[0].width) * data[0].height
        
      videoHtml = "<iframe id='vimeoPlayer' src='#{ movieUrl }' width='#{ width }' height='#{ height }' frameborder='0'></iframe>"
      $("#videoContainer").append(videoHtml)
      iframe = $("#videoContainer iframe")[0]
      caller = this
      onReady = (id) ->
        caller.onReady(id)
        return
      $f(iframe).addEvent("ready", onReady)
    else
      iframe = $("#videoContainer iframe")[0]
      iframe.src = movieUrl

    return

  handle: (presentation) ->
    presentation.chapters[0].media.video.url.toLowerCase().indexOf("http://vimeo.com") != -1

  onReady: (id) ->
    video = $f(id)
    caller = this
    video.addEvent("play", () ->
      caller.video.handleEvent("play")
      return
    )
    video.addEvent("pause", () ->
      caller.video.handleEvent("pause")
      return
    )
    video.addEvent("finish", () ->
      caller.video.handleEvent("finish")
      return
    )
    video.addEvent("playProgress", (data) ->
      caller.currentTimeInSeconds = data.seconds
    )
    video.addEvent("loadProgress", (data) ->
      caller.loadedTimeInSeconds = parseInt(parseFloat(data.duration) * parseFloat(data.percent))
    )
    
    if @wouldPlay
      @wouldPlay = false
      if not @presentz.intervalSet
        @presentz.startTimeChecker()
      video.api("play")

    return

  currentTime: () ->
    @currentTimeInSeconds
    
  skipTo: (time) ->
    if time <= @loadedTimeInSeconds
      $f($("#videoContainer iframe")[0]).api("seekTo", time)
      return true
    return false