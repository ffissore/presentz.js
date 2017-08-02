# Vimeo video plugin handle Vimeo integration
class Vimeo

  # Creates a new instance of the Vimeo video plugin
  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video ["play"], ["pause"], ["finish"], @presentz
    @wouldPlay = false
    @currentTimeInSeconds = 0.0
    @vimeoCallbackFunctionName = @presentz.newElementName("callback")
    window[@vimeoCallbackFunctionName] = @receiveVideoInfo if window? #we don't have a window when testing
    @elementId = @presentz.newElementName()

  # Changes video, by calling Vimeo API and then calling receiveVideoInfo upon completion
  changeVideo: (@videoData, @wouldPlay) ->
    ajaxCall =
      url: "//vimeo.com/api/v2/video/#{@videoId(@videoData)}.json"
      dataType: "jsonp"
      jsonpCallback: @vimeoCallbackFunctionName

    jQuery.ajax ajaxCall
    return

  # Parsers Vimeo url to extract the ID of the video
  videoId: (videoData) ->
    id = videoData.url
    id = id.substr(id.lastIndexOf("/") + 1)
    id = id.substr(0, id.indexOf("?")) if id.indexOf("?") isnt -1
    id

  # Called upon Vimeo API call completion. It's where Vimeo player is actually created (if absent) or modified
  receiveVideoInfo: (data) =>
    movieUrl = "//player.vimeo.com/video/#{@videoId(@videoData)}?api=1&player_id=#{@elementId}"

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

  # Called by presentz when looking up a proper video plugin
  handle: (video) ->
    video.url.toLowerCase().indexOf("//vimeo.com/") isnt -1

  # Called by Vimeo API (aka "Froogaloop") when video is ready
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
      @play()

    return

  # Gets the current time of the played video
  currentTime: () ->
    @currentTimeInSeconds

  # Skips the video to the given time
  skipTo: (time, wouldPlay = false) ->
    if time <= @loadedTimeInSeconds
      @player.api("seekTo", time + 2)
      @play() if wouldPlay
      true
    false

  # Starts playing the video
  play: () ->
    @player.api("play")

  # Pauses the video
  pause: () ->
    @player.api("pause")

  # Returns the pause state of the video
  isPaused: () ->
    @video.isInPauseState

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.Vimeo = Vimeo
