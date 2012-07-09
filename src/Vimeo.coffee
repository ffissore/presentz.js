class Vimeo

  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video "play", "pause", "finish", @presentz
    @wouldPlay = false
    @currentTimeInSeconds = 0.0
    @vimeoCallbackFunctionName = @presentz.newElementName("callback")
    window[@vimeoCallbackFunctionName] = @receiveVideoInfo
    @elementId = @presentz.newElementName()

  changeVideo: (@videoData, @wouldPlay) ->
    ajaxCall =
      url: "http://vimeo.com/api/v2/video/#{videoId(@videoData)}.json"
      dataType: "jsonp"
      jsonpCallback: @vimeoCallbackFunctionName

    $.ajax ajaxCall
    return

  videoId= (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  receiveVideoInfo: (data) =>
    movieUrl = "http://player.vimeo.com/video/#{videoId(@videoData)}?api=1&player_id=#{@elementId}"

    if $(@videoContainer).children().length == 0
      videoHtml = "<iframe id=\"#{@elementId}\" src=\"#{movieUrl}\" width=\"#{@width}\" height=\"#{@height}\" frameborder=\"0\"></iframe>"
      $(@videoContainer).append(videoHtml)

      iframe = $("##{@elementId}")[0]
      onReady= (id) =>
        @onReady(id)
        return
      $f(iframe).addEvent("ready", onReady)
    else
      iframe = $("##{@elementId}")[0]
      iframe.src = movieUrl

    return

  handle: (presentation) ->
    presentation.chapters[0].video.url.toLowerCase().indexOf("http://vimeo.com") != -1

  onReady: (id) ->
    video = $f(id)
    video.addEvent "play", () =>
      @video.handleEvent("play")
      return

    video.addEvent "pause", () =>
      @video.handleEvent("pause")
      return

    video.addEvent "finish", () =>
      @video.handleEvent("finish")
      return

    video.addEvent "playProgress", (data) =>
      @currentTimeInSeconds = data.seconds
      return

    video.addEvent "loadProgress", (data) =>
      @loadedTimeInSeconds = parseInt(parseFloat(data.duration) * parseFloat(data.percent))
      return

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