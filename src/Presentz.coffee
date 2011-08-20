class Presentz

  constructor: () ->
    @videoPlugins = [new Vimeo(this)]
    @defaultVideoPlugin = new Html5Video(this)

  registerVideoPlugin: (plugin) ->
    @videoPlugins.push(plugin)
    return

  init: (@presentation) ->
    @howManyChapters = @presentation.chapters.length
    console.log @presentation.title
    if @presentation.title
    	document.title = @presentation.title
    
    @currentChapterIndex = 0

    #agenda
    @totalDuration += parseInt(chapter.duration) for chapter in @presentation.chapters
    widths = @computeBarWidths(100, true)
    agenda = ''
    for chapterIndex in [0..@presentation.chapters.length-1]
      agenda += "<div title='#{ @presentation.chapters[chapterIndex].title }' style='width: #{ widths[chapterIndex] }%' onclick='changeChapter(#{ chapterIndex }, true);'>&nbsp;</div>"
    
    $("#agendaContainer").html(agenda)
    $("#agendaContainer div[title]").tooltip( {effect : "fade", opacity : 0.7})

    videoPlugins = (plugin for plugin in @videoPlugins when plugin.handle(@presentation))
    if videoPlugins.length > 0
      @videoPlugin = videoPlugins[0]
    else
      @videoPlugin = @defaultVideoPlugin

    return

  computeBarWidths: (max) ->
    chapterIndex = 0
    widths = []
    sumOfWidths = 0
    
    chapterIndex = 0
    for chapter in @presentation.chapters
      width = chapter.durationmax / @totalDuration
      if width == 0
        width = 1
      widths[chapterIndex] = width
      sumOfWidths += width
      chapterIndex++
    
    maxIndex = 0
    if sumOfWidths > (max - 1)
      chapterIndex = 0
      for chapter in @presentation.chapters
        if widths[chapterIndex] > widths[maxIndex]
          maxIndex = chapterIndex;
        chapterIndex++
    
    widths[maxIndex] = widths[maxIndex] - (sumOfWidths - (max - 1));
    return widths;

  changeChapter: (chapterIndex, play) ->
    @currentChapterIndex = chapterIndex
    currentMedia = @presentation.chapters[@currentChapterIndex].media
    @changeSlide(currentMedia.slides[0])
    @videoPlugin.changeVideo(currentMedia.video, play)
    return

  changeSlide: (slideData) ->
    if $("#slideContainer img").length == 0
      $("#slideContainer").empty()
      $("#slideContainer").append("<img width='100%' heigth='100%' src='" + slideData.url + "'>")
    else
      $("#slideContainer img")[0].setAttribute("src", slideData.url)
    return

  checkSlideChange: (currentTime) ->
    slides = @presentation.chapters[@currentChapterIndex].media.slides
    candidateSlide = undefined
    for slide in slides
      if slide.time < currentTime
        candidateSlide = slide

    if candidateSlide != undefined and candidateSlide.url != $("#slideContainer > img")[0].src
      @changeSlide(candidateSlide)

    return

  startTimeChecker: () ->
    clearInterval(@interval)
    @intervalSet = true
    caller = this
    eventHandler = `function() {
      caller.checkState();
    }`
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