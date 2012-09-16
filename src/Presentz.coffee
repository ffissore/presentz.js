class Presentz

  constructor: (videoContainer, videoWxH, slideContainer, slideWxH) ->
    videoWxHParts = videoWxH.split("x")
    slideWxHParts = slideWxH.split("x")

    @availableVideoPlugins =
      vimeo: new Vimeo(@, videoContainer, videoWxHParts[0], videoWxHParts[1])
      youtube: new Youtube(@, videoContainer, videoWxHParts[0], videoWxHParts[1])
      bliptv: new BlipTv(@, videoContainer, videoWxHParts[0], videoWxHParts[1])
      html5: new Html5Video(@, videoContainer, videoWxHParts[0], videoWxHParts[1])

    @availableSlidePlugins =
      slideshare: new SlideShare(@, slideContainer, slideWxHParts[0], slideWxHParts[1])
      swf: new SwfSlide(@, slideContainer, slideWxHParts[0], slideWxHParts[1])
      speakerdeck: new SpeakerDeck(@, slideContainer, slideWxHParts[0], slideWxHParts[1])
      image: new ImgSlide(@, slideContainer, slideWxHParts[0], slideWxHParts[1])

    @videoPlugins = [@availableVideoPlugins.vimeo, @availableVideoPlugins.youtube, @availableVideoPlugins.bliptv]
    @slidePlugins = [@availableSlidePlugins.slideshare, @availableSlidePlugins.swf, @availableSlidePlugins.speakerdeck]
    @defaultVideoPlugin = @availableVideoPlugins.html5
    @defaultSlidePlugin = @availableSlidePlugins.image

    @currentChapterIndex = -1
    @currentChapter = undefined
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
    @videoPlugins.push(@availableVideoPlugins[name])
    return

  registerSlidePlugin: (name, plugin) ->
    @availableSlidePlugins[name] = plugin
    @slidePlugins.push(@availableSlidePlugins[name])
    return

  init: (@presentation) ->
    @stopTimeChecker() if @intervalSet
    
    @currentChapterIndex = -1
    @currentChapter = undefined
    @currentSlideIndex = -1

    @howManyChapters = @presentation.chapters.length

    for chapter in @presentation.chapters
      chapter.video._plugin = @findVideoPlugin(chapter.video)
      for slide in chapter.slides
        slide._plugin = @findSlidePlugin(slide)

    return

  on: (eventType, callback) ->
    @listeners[eventType].push callback

  changeChapter: (chapterIndex, slideIndex, play) ->
    targetChapter = @presentation.chapters[chapterIndex]
    targetSlide = targetChapter.slides[slideIndex]
    if chapterIndex isnt @currentChapterIndex or (@currentChapter? and @currentChapter.video._plugin.skipTo(targetSlide.time, play))
      @changeSlide(targetSlide, chapterIndex, slideIndex)
      if chapterIndex isnt @currentChapterIndex
        targetChapter.video._plugin.changeVideo(targetChapter.video, play)
        targetChapter.video._plugin.skipTo(targetSlide.time, play)
        for listener in @listeners.videochange
          listener(@currentChapterIndex, @currentSlideIndex, chapterIndex, slideIndex)
      @currentChapterIndex = chapterIndex
      @currentChapter = targetChapter
    return

  checkSlideChange: (currentTime) ->
    slides = @presentation.chapters[@currentChapterIndex].slides
    for slide in slides when slide.time <= currentTime
      candidateSlide = slide

    if candidateSlide? and @currentSlide.url isnt candidateSlide.url
      @changeSlide(candidateSlide, @currentChapterIndex, slides.indexOf(candidateSlide))
      
    for listener in @listeners.timechange
      listener(currentTime)

    return

  changeSlide: (slide, chapterIndex, slideIndex) ->
    @currentSlide = slide
    slide._plugin.changeSlide(slide)

    previousSlideIndex = @currentSlideIndex
    @currentSlideIndex = slideIndex

    next4Slides = @presentation.chapters[chapterIndex].slides[(slideIndex + 1)..(slideIndex + 5)]
    for nextSlide in next4Slides
      nextSlide._plugin.preload nextSlide if nextSlide._plugin.preload?

    for listener in @listeners.slidechange
      listener(@currentChapterIndex, previousSlideIndex, chapterIndex, slideIndex)
    return

  findVideoPlugin: (video) ->
    plugins = (plugin for plugin in @videoPlugins when plugin.handle(video))
    return plugins[0] if plugins.length > 0
    return @defaultVideoPlugin

  findSlidePlugin: (slide) ->
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
    @checkSlideChange(@currentChapter.video._plugin.currentTime()) if @currentChapter?
    return

  newElementName: (prefix) ->
    if prefix?
      "#{prefix}_#{Math.round(Math.random() * 1000000)}"
    else
      "element_#{Math.round(Math.random() * 1000000)}"

  pause: () ->
    @currentChapter.video._plugin.pause() if @currentChapter?

  isPaused: () ->
    @currentChapter.video._plugin.isPaused() if @currentChapter?

  play: () ->
    @currentChapter.video._plugin.play() if @currentChapter?

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
