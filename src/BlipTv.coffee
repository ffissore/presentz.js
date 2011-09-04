class BlipTv

  constructor: (@presentz) ->
    @video = new Html5Video @presentz

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
    @adjustSize = @video.adjustSize
    @currentTime = @video.currentTime
    @skipTo = @video.skipTo
    return

  handle: (presentation) ->
    presentation.chapters[0].media.video.url.toLowerCase().indexOf("http://blip.tv") != -1
