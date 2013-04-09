# Html5Video video plugin handles urls directly pointing to video files
class Html5Video

  # Creates a new instance of the Html5Video video plugin
  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video ["play"], ["pause"], ["ended"], @presentz
    @elementId = @presentz.newElementName()

  # Called by presentz when looking up a proper video plugin
  handle: (video) -> true

  # Changes video, creating a new &lt;video&gt; tag and decorating it with MediaElementPlayer
  changeVideo: (videoData, @wouldPlay) ->
    $videoContainer = jQuery(@videoContainer)
    $videoContainer.empty()
    $videoContainer.append("<video id=\"#{@elementId}\" controls preload=\"none\" src=\"#{videoData.url}\" width=\"100%\" height=\"100%\"></video>")

    playerOptions =
      timerRate: 500
      success: (me) =>
        @onPlayerLoaded(me)
        return

    new MediaElementPlayer("##{@elementId}", playerOptions)
    return

  # Called by MediaElementPlayer when ready
  onPlayerLoaded: (@player) ->
    eventHandler = (event) =>
      @video.handleEvent(event.type)
      return
    @player.addEventListener("play", eventHandler, false)
    @player.addEventListener("pause", eventHandler, false)
    @player.addEventListener("ended", eventHandler, false)

    @player.load()
    @play() if @wouldPlay

    return

  # Gets the current time of the played video
  currentTime: () ->
    @player.currentTime

  # Skips the video to the given time
  skipTo: (time, wouldPlay = false) ->
    if @player? and @player.currentTime > 0
      @player.setCurrentTime(time)
      @play() if wouldPlay
      true
    false

  # Starts playing the video
  play: () ->
    @player.play()

  # Pauses the video
  pause: () ->
    @player.pause()

  # Returns the pause state of the video
  isPaused: () ->
    @video.isInPauseState

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.Html5Video = Html5Video
