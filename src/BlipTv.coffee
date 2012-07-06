class BlipTv

  constructor: (@presentz, videoContainer, width, height) ->
    @video = new Html5Video @presentz, videoContainer, width, height

  changeVideo: (videoData, @wouldPlay) ->
    ajaxCall =
      url: videoData.url
      dataType: "jsonp"
      data: "skin=json"
      jsonpCallback: "presentz.videoPlugin.receiveVideoInfo"

    $.ajax ajaxCall
    return

  receiveVideoInfo: (data) ->
    fakeVideoData =
      url: data[0].Post.media.url
    @video.changeVideo(fakeVideoData, @wouldPlay)
    @player = @video.player
    @skipTo = @video.skipTo
    return

  handle: (presentation) ->
    presentation.chapters[0].video.url.toLowerCase().indexOf("http://blip.tv") != -1

  currentTime: () ->
    return @video.currentTime()

  skipTo: (time) ->
    return @video.skipTo(time)
