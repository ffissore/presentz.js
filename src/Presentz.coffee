class Presentz

  constructor: (videoContainer, slideContainer, agendaContainer) ->
    @videoPlugins = [new Vimeo(this, videoContainer), new Youtube(this, videoContainer), new BlipTv(this, videoContainer)]
    @slidePlugins = [new SlideShare(slideContainer), new SwfSlide(slideContainer)]
    @defaultVideoPlugin = new Html5Video(this, videoContainer)
    @defaultSlidePlugin = new ImgSlide(slideContainer)
    @currentChapterIndex = -1
    if !agendaContainer?
      @agenda = new NullAgenda()
    else
      @agenda = new Agenda(agendaContainer)

  registerVideoPlugin: (plugin) ->
    @videoPlugins.push(plugin)
    return

  registerSlidePlugin: (plugin) ->
    @slidePlugins.push(plugin)
    return

  init: (@presentation) ->
    @howManyChapters = @presentation.chapters.length
    if @presentation.title?
      document.title = @presentation.title

    @agenda.build(@presentation)

    @videoPlugin = @findVideoPlugin()

    return

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

    @agenda.select(@presentation, chapterIndex, slideIndex)
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
    caller = this
    timeChecker = () ->
      caller.videoPlugin.adjustSize()
      caller.slidePlugin.adjustSize()
      caller.checkState()
      return
    @interval = setInterval(timeChecker, 500);
    return

  stopTimeChecker: () ->
    clearInterval(@interval)
    @intervalSet = false
    return

  checkState: () ->
    @checkSlideChange(@videoPlugin.currentTime())
    return

window.Presentz = Presentz

