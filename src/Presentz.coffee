class Presentz

  constructor: (videoContainer, videoWxH, slideContainer, slideWxH) ->
    videoWxHParts = videoWxH.split("x")
    slideWxHParts = slideWxH.split("x")
    @videoPlugins = [new Vimeo(@, videoContainer, videoWxHParts[0], videoWxHParts[1]), new YoutubeIFrame(@, videoContainer, videoWxHParts[0], videoWxHParts[1]), new BlipTv(@, videoContainer, videoWxHParts[0], videoWxHParts[1])]
    @slidePlugins = [new SlideShare(@, slideContainer, slideWxHParts[0], slideWxHParts[1]), new SwfSlide(@, slideContainer, slideWxHParts[0], slideWxHParts[1]),  new SpeakerDeck(@, slideContainer, slideWxHParts[0], slideWxHParts[1])]
    @defaultVideoPlugin = new Html5Video(@, videoContainer, videoWxHParts[0], videoWxHParts[1])
    @defaultSlidePlugin = new ImgSlide(@, slideContainer, slideWxHParts[0], slideWxHParts[1])
    @currentChapterIndex = -1
    @currentSlideIndex = -1
    @listeners =
      slidechange: []
      videochange: []

  registerVideoPlugin: (plugin) ->
    @videoPlugins.push(plugin)
    return

  registerSlidePlugin: (plugin) ->
    @slidePlugins.push(plugin)
    return

  init: (@presentation) ->
    @howManyChapters = @presentation.chapters.length

    @videoPlugin = @findVideoPlugin()

    return

  on: (eventType, callback) ->
    @listeners[eventType].push callback

  changeChapter: (chapterIndex, slideIndex, play) ->
    targetChapter = @presentation.chapters[chapterIndex]
    targetSlide = targetChapter.slides[slideIndex]
    if chapterIndex isnt @currentChapterIndex or @videoPlugin.skipTo(targetSlide.time)
      @changeSlide(targetSlide, chapterIndex, slideIndex)
      if chapterIndex isnt @currentChapterIndex
        @videoPlugin.changeVideo(targetChapter.video, play)
        @videoPlugin.skipTo(targetSlide.time)
        for listener in @listeners.videochange
          listener(@currentChapterIndex, @currentSlideIndex, chapterIndex, slideIndex)
      @currentChapterIndex = chapterIndex
    return

  checkSlideChange: (currentTime) ->
    slides = @presentation.chapters[@currentChapterIndex].slides
    for slide in slides when slide.time <= currentTime
      candidateSlide = slide

    if candidateSlide? and @currentSlide.url != candidateSlide.url
      @changeSlide(candidateSlide, @currentChapterIndex, slides.indexOf(candidateSlide))

    return

  changeSlide: (slide, chapterIndex, slideIndex) ->
    @currentSlide = slide
    @slidePlugin = @findSlidePlugin(slide)
    @slidePlugin.changeSlide(slide)

    previousSlideIndex = @currentSlideIndex
    @currentSlideIndex = slideIndex
    
    slides = @presentation.chapters[chapterIndex].slides
    slides = slides[(slideIndex + 1)..(slideIndex + 5)]
    @findSlidePlugin(slide).preload slides

    for listener in @listeners.slidechange
      listener(@currentChapterIndex, previousSlideIndex, chapterIndex, slideIndex)
    return

  findVideoPlugin: () ->
    plugins = (plugin for plugin in @videoPlugins when plugin.handle(@presentation))
    return plugins[0] if plugins.length > 0
    return @defaultVideoPlugin

  findSlidePlugin: (slide) ->
    plugins = (plugin for plugin in @slidePlugins when plugin.handle(slide))
    return plugins[0] if plugins.length > 0
    return @defaultSlidePlugin

  startTimeChecker: () ->
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
    @checkSlideChange(@videoPlugin.currentTime())
    return

  newElementName: (prefix) ->
    if prefix?
      "#{prefix}_#{Math.round(Math.random() * 1000000)}"
    else
      "element_#{Math.round(Math.random() * 1000000)}"

  pause: () ->
    @videoPlugin.pause()

  play: () ->
    @videoPlugin.play()

window.Presentz = Presentz

