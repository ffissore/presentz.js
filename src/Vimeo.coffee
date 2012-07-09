class Vimeo

  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video "play", "pause", "finish", @presentz
    @wouldPlay = false
    @currentTimeInSeconds = 0.0
    @vimeoCallbackFunction = "vimeoCallback#{ parseInt(Math.random() * 1000000000) }"
    window[@vimeoCallbackFunction] = @receiveVideoInfo

  changeVideo: (@videoData, @wouldPlay) ->
    ajaxCall =
      url: "http://vimeo.com/api/v2/video/#{ videoId(@videoData) }.json"
      dataType: "jsonp"
      jsonpCallback: @vimeoCallbackFunction

    $.ajax ajaxCall
    return

  videoId = (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  receiveVideoInfo: (data) =>
    movieUrl = "http://player.vimeo.com/video/#{ videoId(@videoData) }?api=1&player_id=vimeoPlayer"

    if $(@videoContainer).children().length == 0
      #width = $(@videoContainer).width()
      #height = (width / data[0].width) * data[0].height
      #@sizer = new Sizer(width, height, @videoContainer)

      videoHtml = "<iframe id=\"vimeoPlayer\" src=\"#{movieUrl}\" width=\"#{@width}\" height=\"#{@height}\" frameborder=\"0\"></iframe>"
      $(@videoContainer).append(videoHtml)

      iframe = $("#{@videoContainer} iframe")[0]
      onReady = (id) =>
        @onReady(id)
        return
      $f(iframe).addEvent("ready", onReady)
    else
      iframe = $("#{@videoContainer} iframe")[0]
      iframe.src = movieUrl

    return

  handle: (presentation) ->
    presentation.chapters[0].video.url.toLowerCase().indexOf("http://vimeo.com") != -1

  onReady: (id) ->
    video = $f(id)
    video.addEvent("play", () =>
      @video.handleEvent("play")
      return
    )
    video.addEvent("pause", () =>
      @video.handleEvent("pause")
      return
    )
    video.addEvent("finish", () =>
      @video.handleEvent("finish")
      return
    )
    video.addEvent("playProgress", (data) =>
      @currentTimeInSeconds = data.seconds
    )
    video.addEvent("loadProgress", (data) =>
      @loadedTimeInSeconds = parseInt(parseFloat(data.duration) * parseFloat(data.percent))
    )

    if @wouldPlay
      @wouldPlay = false
      if !@presentz.intervalSet
        @presentz.startTimeChecker()
      video.api("play")

    return

  currentTime: () ->
    @currentTimeInSeconds

  skipTo: (time) ->
    if time <= @loadedTimeInSeconds
      player = $f($("#{@videoContainer} iframe")[0])
      player.api("seekTo", time)
      return true
    return false