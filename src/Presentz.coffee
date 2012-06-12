class Presentz

  constructor: (videoContainer, videoWxH, slideContainer, slideWxH) ->
    videoWxHParts = videoWxH.split("x")
    slideWxHParts = slideWxH.split("x")
    @videoPlugins = [new Vimeo(this, videoContainer, videoWxHParts[0], videoWxHParts[1]), new Youtube(this, videoContainer, videoWxHParts[0], videoWxHParts[1]), new BlipTv(this, videoContainer, videoWxHParts[0], videoWxHParts[1])]
    @slidePlugins = [new SlideShare(slideContainer, slideWxHParts[0], slideWxHParts[1]), new SwfSlide(slideContainer, slideWxHParts[0], slideWxHParts[1])]
    @defaultVideoPlugin = new Html5Video(this, videoContainer, videoWxHParts[0], videoWxHParts[1])
    @defaultSlidePlugin = new ImgSlide(slideContainer, slideWxHParts[0], slideWxHParts[1])
    @currentChapterIndex = -1
    @listeners =
      slidechange: []

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
    currentMedia = @presentation.chapters[chapterIndex].media
    currentSlide = currentMedia.slides[slideIndex]
    if chapterIndex != @currentChapterIndex or @videoPlugin.skipTo(currentSlide.time)
      @changeSlide(currentSlide, chapterIndex, slideIndex)
      if chapterIndex != @currentChapterIndex
        @videoPlugin.changeVideo(currentMedia.video, play)
        @videoPlugin.skipTo(currentSlide.time)
      @currentChapterIndex = chapterIndex
    return

  checkSlideChange: (currentTime) ->
    slides = @presentation.chapters[@currentChapterIndex].media.slides
    for slide in slides when slide.time <= currentTime
      candidateSlide = slide

    if candidateSlide? and @currentSlide.url != candidateSlide.url
      @changeSlide(candidateSlide, @currentChapterIndex, slides.indexOf(candidateSlide))

    return

  changeSlide: (slide, chapterIndex, slideIndex) ->
    @currentSlide = slide
    @slidePlugin = @findSlidePlugin(slide)
    @slidePlugin.changeSlide(slide)

    slides = @presentation.chapters[chapterIndex].media.slides
    slides = slides[(slideIndex + 1)..(slideIndex + 5)]
    @findSlidePlugin(slide).preload slides

    for listener in @listeners.slidechange
      listener(slideIndex)
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
    timeChecker = () =>
      #this.videoPlugin.adjustSize()
      #this.slidePlugin.adjustSize()
      this.checkState()
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

window.Presentz = Presentz

