class Presentz

  constructor: () ->
    @videoPlugins = [new Vimeo(this), new Youtube(this), new BlipTv(this)]
    @slidePlugins = [new SlideShare(), new SwfSlide()]
    @defaultVideoPlugin = new Html5Video(this)
    @defaultSlidePlugin = new ImgSlide()
    @currentChapterIndex = -1

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

    #agenda
    totalDuration = 0
    totalDuration += Math.round(chapter.duration) for chapter in @presentation.chapters
    widths = computeBarWidths(totalDuration, $("#agendaContainer").width(), @presentation.chapters)
    agenda = ''
    for chapterIndex in [0..widths.length-1]
      for slideIndex in [0..widths[chapterIndex].length-1]
        if @presentation.chapters[chapterIndex].media.slides[slideIndex].title
          title = @presentation.chapters[chapterIndex].media.slides[slideIndex].title
        else
          title = "#{ @presentation.chapters[chapterIndex].title } - Slide #{ slideIndex + 1 }"
        agenda += "<div style='width: #{ widths[chapterIndex][slideIndex] }px' onclick='presentz.changeChapter(#{ chapterIndex }, #{ slideIndex }, true);'><div class='progress'></div><div class='info'>#{ title }</div></div>"

    $("#agendaContainer").html(agenda)

    videoPlugins = (plugin for plugin in @videoPlugins when plugin.handle(@presentation))
    if videoPlugins.length > 0
      @videoPlugin = videoPlugins[0]
    else
      @videoPlugin = @defaultVideoPlugin

    return

  computeBarWidths= (duration, maxWidth, chapters) ->
    widths = new Array()
    chapterIndex = 0
    for chapter in chapters
      widths[chapterIndex] = new Array()
      clength = Math.round((chapter.duration * maxWidth / duration) - 1)
      slideWidthSum = 0
      slides = chapter.media.slides
      for slideIndex in [1..slides.length - 1] when slides.length > 1
        slideWidth = Math.round(clength * slides[slideIndex].time / chapter.duration - slideWidthSum) - 1
        slideWidth = if slideWidth > 0 then slideWidth else 1
        slideWidthSum += slideWidth + 1
        widths[chapterIndex][slideIndex - 1] = slideWidth
      widths[chapterIndex][slides.length - 1] = clength - slideWidthSum - 1
      chapterIndex++
    return widths

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

    if candidateSlide != undefined and @isCurrentSlideDifferentFrom(candidateSlide)
      @changeSlide(candidateSlide, @currentChapterIndex, slideIndex)

    return

  isCurrentSlideDifferentFrom: (slide) ->
    @currentSlide.url != slide.url
    
  changeSlide: (slide, chapterIndex, slideIndex) ->
    @currentSlide = slide
    @findSlidePlugin(slide).changeSlide(slide)
    
    for index in [1..$("#agendaContainer div").length]
      $("#agendaContainer div:nth-child(#{index})").removeClass("agendaselected")
    
    currentSlideIndex = slideIndex
    for index in [0..chapterIndex-1] when chapterIndex - 1 >= 0  
      currentSlideIndex += @presentation.chapters[index].media.slides.length
    $("#agendaContainer div:nth-child(#{currentSlideIndex + 1})").addClass("agendaselected")
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
    eventHandler = () ->
      caller.checkState()
      return
    @interval = setInterval(eventHandler, 500);
    return

  stopTimeChecker: () ->
    clearInterval(@interval)
    @intervalSet = false
    return

  checkState: () ->
    @checkSlideChange(@videoPlugin.currentTime())
    return

window.Presentz = Presentz