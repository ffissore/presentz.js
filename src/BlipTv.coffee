# Although still here, BlipTV is no longer supported
class BlipTv

  constructor: (@presentz, videoContainer, width, height) ->
    @video = new Html5Video @presentz, videoContainer, width, height

  changeVideo: (videoData, @wouldPlay) ->
    ajaxCall =
      url: videoData.url
      dataType: "jsonp"
      data: "skin=json"
      jsonpCallback: "presentz.videoPlugin.receiveVideoInfo"

    jQuery.ajax ajaxCall
    return

  receiveVideoInfo: (data) ->
    fakeVideoData =
      url: data[0].Post.media.url
    @video.changeVideo(fakeVideoData, @wouldPlay)
    @player = @video.player
    @skipTo = @video.skipTo
    return

  handle: (video) ->
    video.url.toLowerCase().indexOf("//blip.tv") isnt -1

  currentTime: () ->
    @video.currentTime()

  skipTo: (time, wouldPlay = false) ->
    @video.skipTo(time, wouldPlay)

  play: () ->
    @video.play()

  pause: () ->
    @video.pause()

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.BlipTv = BlipTv
