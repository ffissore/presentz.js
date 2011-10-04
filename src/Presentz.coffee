class Presentz

  constructor: (videoContainer, slideContainer, agendaContainer) ->
    @videoPlugins = [new Vimeo(this, videoContainer), new Youtube(this, videoContainer), new BlipTv(this, videoContainer)]
    @slidePlugins = [new SlideShare(slideContainer), new SwfSlide(slideContainer)]
    @defaultVideoPlugin = new Html5Video(this, videoContainer)
    @defaultSlidePlugin = new ImgSlide(slideContainer)
    @currentChapterIndex = -1
    @agenda = new Agenda(agendaContainer)

  registerVideoPlugin: (plugin) ->
    @videoPlugins.push(plugin)
    return

  registerSlidePlugin: (plugin) ->
    @slidePlugins.push(plugin)
    return

  init: (@presentation) ->
    @howManyChapters = @presentation.chapters.length
    if @presentation.title
      document.title = @presentation.title

    @agenda.build(@presentation)

    videoPlugins = (plugin for plugin in @videoPlugins when plugin.handle(@presentation))
    if videoPlugins.length > 0
      @videoPlugin = videoPlugins[0]
    else
      @videoPlugin = @defaultVideoPlugin

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
    candidateSlide = undefined
    slideIndex = -1
    for slide in slides when slide.time < currentTime
      candidateSlide = slide
      slideIndex++

    if candidateSlide != undefined and @currentSlide.url != candidateSlide.url
      @changeSlide(candidateSlide, @currentChapterIndex, slideIndex)

    return
    
  changeSlide: (slide, chapterIndex, slideIndex) ->
    @currentSlide = slide
    @slidePlugin = @findSlidePlugin(slide)
    @slidePlugin.changeSlide(slide)

    @agenda.select(@presentation, chapterIndex, slideIndex)    
    return
    
  findSlidePlugin: (slide) ->
    slidePlugins = (plugin for plugin in @slidePlugins when plugin.handle(slide))
    if slidePlugins.length > 0
      return slidePlugins[0]
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