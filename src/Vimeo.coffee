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

    jQuery.ajax ajaxCall
    return

  videoId= (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  receiveVideoInfo: (data) =>
    movieUrl = "http://player.vimeo.com/video/#{videoId(@videoData)}?api=1&player_id=#{@elementId}"

    if jQuery("##{@elementId}").length is 0
      videoHtml = "<iframe id=\"#{@elementId}\" src=\"#{movieUrl}\" width=\"#{@width}\" height=\"#{@height}\" frameborder=\"0\"></iframe>"
      jQuery(@videoContainer).append(videoHtml)

      iframe = jQuery("##{@elementId}")[0]
      onReady= (id) =>
        @onReady(id)
        return
      $f(iframe).addEvent("ready", onReady)
    else
      iframe = jQuery("##{@elementId}")[0]
      iframe.src = movieUrl

    return

  handle: (video) ->
    video.url.toLowerCase().indexOf("http://vimeo.com") isnt -1

  onReady: (id) ->
    @player = $f(id)
    @player.addEvent "play", () =>
      @video.handleEvent("play")
      return

    @player.addEvent "pause", () =>
      @video.handleEvent("pause")
      return

    @player.addEvent "finish", () =>
      @video.handleEvent("finish")
      return

    @player.addEvent "playProgress", (data) =>
      @currentTimeInSeconds = data.seconds
      return

    @player.addEvent "loadProgress", (data) =>
      @loadedTimeInSeconds = parseInt(parseFloat(data.duration) * parseFloat(data.percent))
      return

    if @wouldPlay
      @wouldPlay = false
      if !@presentz.intervalSet
        @presentz.startTimeChecker()
      @player.api("play")

    return

  currentTime: () ->
    @currentTimeInSeconds

  skipTo: (time, wouldPlay = false) ->
    if time <= @loadedTimeInSeconds
      @player.api("seekTo", time)
      @player.api("play") if wouldPlay
      true
    false

  play: () ->
    @player.api("play")

  pause: () ->
    @player.api("pause")

  isPaused: () ->
    @video.isPaused()