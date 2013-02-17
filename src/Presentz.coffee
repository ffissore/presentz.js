class Presentz

  EMPTY_FUNCTION = () ->

  toWidthHeight = (str) ->
    parts = str.split("x")
    widthHeight =
      width: jQuery.trim(parts[0])
      height: jQuery.trim(parts[1])

  constructor: (videoContainer, videoWxH, slideContainer, slideWxH) ->
    sizeOfVideo = toWidthHeight(videoWxH)
    sizeOfSlide = toWidthHeight(slideWxH)

    @availableVideoPlugins =
      vimeo: new Vimeo(@, videoContainer, sizeOfVideo.width, sizeOfVideo.height)
      youtube: new Youtube(@, videoContainer, sizeOfVideo.width, sizeOfVideo.height)
      bliptv: new BlipTv(@, videoContainer, sizeOfVideo.width, sizeOfVideo.height)
      html5: new Html5Video(@, videoContainer, sizeOfVideo.width, sizeOfVideo.height)

    @availableSlidePlugins =
      slideshare: new SlideShare(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      slideshareoembed: new SlideShareOEmbed(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      swf: new SwfSlide(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      speakerdeck: new SpeakerDeck(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      image: new ImgSlide(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      iframe: new IFrameSlide(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      rvlio: new RvlIO(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      none: new NoSlide()

    @videoPlugins = [@availableVideoPlugins.vimeo, @availableVideoPlugins.youtube, @availableVideoPlugins.bliptv]
    @slidePlugins = [@availableSlidePlugins.slideshare, @availableSlidePlugins.slideshareoembed, @availableSlidePlugins.swf, @availableSlidePlugins.speakerdeck, @availableSlidePlugins.rvlio, @availableSlidePlugins.none]
    @defaultVideoPlugin = @availableVideoPlugins.html5
    @defaultSlidePlugin = @availableSlidePlugins.image

    @currentChapterIndex = -1
    @currentSlideIndex = -1
    @listeners =
      slidechange: []
      videochange: []
      timechange: []
      play: []
      pause: []
      finish: []

    @isSynchronized = true

  registerVideoPlugin: (name, plugin) ->
    @availableVideoPlugins[name] = plugin
    @videoPlugins.push(plugin)
    return

  registerSlidePlugin: (name, plugin) ->
    @availableSlidePlugins[name] = plugin
    @slidePlugins.push(plugin)
    return

  init: (@presentation) ->
    @stopTimeChecker() if @intervalSet

    @currentChapterIndex = -1
    @currentSlideIndex = -1

    for chapter in @presentation.chapters
      chapter.video._plugin = @findVideoPlugin(chapter.video)
      for slide in chapter.slides
        slide._plugin = @findSlidePlugin(slide)
      if !chapter.duration? and chapter.slides? and chapter.slides.length > 0
        chapter.duration = chapter.slides[chapter.slides.length - 1].time + 5

    return

  on: (eventType, callback) ->
    @listeners[eventType].push(callback)

  changeChapter: (chapterIndex, slideIndex, play, callback = EMPTY_FUNCTION) ->
    targetChapter = @presentation.chapters[chapterIndex]
    return callback("no chapter at index #{chapterIndex}") unless targetChapter?

    targetSlide = targetChapter.slides[slideIndex]
    return callback("no slide at index #{slideIndex}") unless targetSlide?

    if chapterIndex isnt @currentChapterIndex or (@currentChapterIndex isnt -1 and @presentation.chapters[@currentChapterIndex].video._plugin.skipTo(targetSlide.time, play))
      @changeSlide(chapterIndex, slideIndex)
      if chapterIndex isnt @currentChapterIndex
        targetChapter.video._plugin.changeVideo(targetChapter.video, play)
        targetChapter.video._plugin.skipTo(targetSlide.time, play)
        for listener in @listeners.videochange
          listener(@currentChapterIndex, @currentSlideIndex, chapterIndex, slideIndex)
      @currentChapterIndex = chapterIndex

    callback()
    return

  changeSlide: (chapterIndex, slideIndex) ->
    slide = @presentation.chapters[chapterIndex].slides[slideIndex]
    slide._plugin.changeSlide(slide)

    previousSlideIndex = @currentSlideIndex
    @currentSlideIndex = slideIndex

    next4Slides = @presentation.chapters[chapterIndex].slides[(slideIndex + 1)..(slideIndex + 5)]
    for nextSlide in next4Slides
      nextSlide._plugin.preload(nextSlide) if nextSlide._plugin.preload?

    for listener in @listeners.slidechange
      listener(@currentChapterIndex, previousSlideIndex, chapterIndex, slideIndex)

    return

  checkSlideChange: (currentTime) ->
    slides = @presentation.chapters[@currentChapterIndex].slides
    for slide in slides when slide.time <= currentTime
      candidateSlide = slide

    if candidateSlide? and slides.indexOf(candidateSlide) isnt @currentSlideIndex
      @changeSlide(@currentChapterIndex, slides.indexOf(candidateSlide))

    for listener in @listeners.timechange
      listener(currentTime)

    return

  findVideoPlugin: (video) ->
    return @availableVideoPlugins[video._plugin_id] if video._plugin_id? and @availableVideoPlugins[video._plugin_id]?

    plugins = (plugin for plugin in @videoPlugins when plugin.handle(video))
    return plugins[0] if plugins.length > 0
    return @defaultVideoPlugin

  findSlidePlugin: (slide) ->
    return @availableSlidePlugins[slide._plugin_id] if slide._plugin_id? and @availableSlidePlugins[slide._plugin_id]?

    plugins = (plugin for plugin in @slidePlugins when plugin.handle(slide))
    return plugins[0] if plugins.length > 0
    return @defaultSlidePlugin

  synchronized: (@isSynchronized) ->
    @stopTimeChecker() if @intervalSet and !@isSynchronized
    @startTimeChecker() if !@intervalSet and @isSynchronized and !@isPaused()

  startTimeChecker: () ->
    return unless @isSynchronized

    clearInterval(@interval)
    @intervalSet = true
    timeChecker= () =>
      @checkState()
      return
    @interval = setInterval(timeChecker, 500)
    return

  stopTimeChecker: () ->
    clearInterval(@interval)
    @intervalSet = false
    return

  checkState: () ->
    @checkSlideChange(@presentation.chapters[@currentChapterIndex].video._plugin.currentTime()) if @currentChapterIndex isnt -1
    return

  newElementName: (prefix) ->
    if prefix?
      "#{prefix}_#{Math.round(Math.random() * 1000000)}"
    else
      "element_#{Math.round(Math.random() * 1000000)}"

  pause: () ->
    @presentation.chapters[@currentChapterIndex].video._plugin.pause() if @currentChapterIndex isnt -1

  isPaused: () ->
    @presentation.chapters[@currentChapterIndex].video._plugin.isPaused() if @currentChapterIndex isnt -1

  play: () ->
    @presentation.chapters[@currentChapterIndex].video._plugin.play() if @currentChapterIndex isnt -1

  next: () ->
    if @presentation.chapters[@currentChapterIndex].slides.length > @currentSlideIndex + 1
      @changeChapter @currentChapterIndex, @currentSlideIndex + 1, true
      return true
    if @presentation.chapters.length > @currentChapterIndex + 1
      @changeChapter @currentChapterIndex + 1, 0, true
      return true
    return false

  previous: () ->
    if @currentSlideIndex - 1 >= 0
      @changeChapter @currentChapterIndex, @currentSlideIndex - 1, true
      return true
    if @currentChapterIndex - 1 >= 0
      @changeChapter @currentChapterIndex - 1, @presentation.chapters[@currentChapterIndex - 1].slides.length - 1, true
      return true
    return false

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.Presentz = Presentz
root.Presentz = Presentz
