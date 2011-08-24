class BlipTv

  constructor: (@presentz) ->
    @video = new Video 1, 2, 0, @presentz
    PokkariPlayerOptions.showPlayerOptions.playerUrl = "https://blip.tv/scripts/flash/stratos.swf"

  changeVideo: (videoData, @wouldPlay) ->
    if $("#videoContainer").children().length == 0
      $("#videoContainer").append("<div id='bliptvcontainer'></div>")
      
    ajaxCall =
      url: videoData.url
      dataType: "jsonp"
      data: "skin=json"
      jsonpCallback: "presentz.videoPlugin.receiveVideoInfo"

    $.ajax ajaxCall
    return

  receiveVideoInfo: (data) ->
    mediaUrl = data[0].Post.media.url
    mimeType = data[0].Post.media.mimeType.split(",")[0]
    console.log "#{mediaUrl}?source=1"
    console.log mimeType
    
    @player = PokkariPlayer.GetInstanceByMimeType mimeType
    @player.setPrimaryMediaUrl "#{mediaUrl}?source=1"
    @player.setAutoPlay @wouldPlay
    @player.setPermalinkUrl("http://blipdev.pokkari.net/file/view/32815?source=1")
    @player.setAdvertisingType(0)
    @player.setPostsId(35785)

    @player.setPlayerTarget  document.getElementById("bliptvcontainer")
    @player.render()

  handle: (presentation) ->
    presentation.chapters[0].media.video.url.toLowerCase().indexOf("http://blip.tv") != -1

  currentTime: () ->
    return presentz.videoPlugin.player.getCurrentTime()
