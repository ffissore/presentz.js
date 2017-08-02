# Presentz is the main (and, hopefully, only) class whose API you need to know
class Presentz

  # Used as default callback function
  EMPTY_FUNCTION = () ->

  toWidthHeight = (str) ->
    parts = str.split("x")
    widthHeight =
      width: jQuery.trim(parts[0])
      height: jQuery.trim(parts[1])

  # Builds a new presentz instance                                    
  constructor: (videoContainer, videoWxH, slideContainer, slideWxH) ->
    sizeOfVideo = toWidthHeight(videoWxH)
    sizeOfSlide = toWidthHeight(slideWxH)

    # Creates new instances of each built-in plugin and put them in the availableVideoPlugins and availableSlidePlugins instance variables
    @availableVideoPlugins =
      vimeo: new Vimeo(@, videoContainer, sizeOfVideo.width, sizeOfVideo.height)
      youtube: new Youtube(@, videoContainer, sizeOfVideo.width, sizeOfVideo.height)
      wistia_plugin: new WistiaPlugin(@, videoContainer, sizeOfVideo.width, sizeOfVideo.height)
      sambatech_plugin: new SambatechPlugin(@, videoContainer, sizeOfVideo.width, sizeOfVideo.height)
      html5: new Html5Video(@, videoContainer, sizeOfVideo.width, sizeOfVideo.height)

    @availableSlidePlugins =
      slideshareoembed: new SlideShareOEmbed(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      swf: new SwfSlide(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      speakerdeck: new SpeakerDeck(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      image: new ImgSlide(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      iframe: new IFrameSlide(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      rvlio: new RvlIO(@, slideContainer, sizeOfSlide.width, sizeOfSlide.height)
      none: new NoSlide()

    # When looking for a plugin able to handle a video/slide url, presentz consults the videoPlugins and slidePlugins instance variables: you can avoid such lookup by specifying the plugin to use
    @videoPlugins = [@availableVideoPlugins.vimeo, @availableVideoPlugins.youtube, @availableVideoPlugins.wistia_plugin, @availableVideoPlugins.sambatech_plugin]
    @slidePlugins = [@availableSlidePlugins.slideshareoembed, @availableSlidePlugins.swf, @availableSlidePlugins.speakerdeck, @availableSlidePlugins.rvlio, @availableSlidePlugins.none]
    # When no plugin seems able to handle given video/slide, default ones are used
    @defaultVideoPlugin = @availableVideoPlugins.html5
    @defaultSlidePlugin = @availableSlidePlugins.image

    @currentChapterIndex = -1
    @currentSlideIndex = -1

    # List of listeners for each event type
    @listeners =
      slidechange: []
      videochange: []
      timechange: []
      play: []
      pause: []
      finish: []

    # There are times when you DON'T want your slides synchronized with the video
    @isSynchronized = true

  # Before calling init(), if you have your own video plugin, register it
  registerVideoPlugin: (name, plugin) ->
    @availableVideoPlugins[name] = plugin
    @videoPlugins.push(plugin)
    return

  # Before calling init(), if you have your own slide plugin, register it
  registerSlidePlugin: (name, plugin) ->
    @availableSlidePlugins[name] = plugin
    @slidePlugins.push(plugin)
    return

  # Init presentz with the presentation to show: a _plugin field will be added to each video and slide object, holding a reference to the proper video/slide plugin
  init: (@presentation) ->
    @stopTimeChecker() if @intervalSet

    @currentChapterIndex = -1
    @currentSlideIndex = -1

    for chapter in @presentation.chapters
      chapter.video._plugin = findVideoPlugin(@, chapter.video)
      for slide in chapter.slides
        slide._plugin = findSlidePlugin(@, slide)
      if !chapter.duration? and chapter.slides? and chapter.slides.length > 0
        chapter.duration = chapter.slides[chapter.slides.length - 1].time + 5

    return

  # Register a listener to an event of the given type
  on: (eventType, callback) ->
    @listeners[eventType].push(callback)

  # Changes chapter: each chapter has one video, so you can think of this function as "changeVideo"
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

  # Changes slide. it will also ask the next 4 slides to preload themselves
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

  # Checks if the currently displayed slide has to be changed
  checkSlideChange: (currentTime) ->
    slides = @presentation.chapters[@currentChapterIndex].slides
    for slide in slides when slide.time <= currentTime
      candidateSlide = slide

    if candidateSlide? and slides.indexOf(candidateSlide) isnt @currentSlideIndex
      @changeSlide(@currentChapterIndex, slides.indexOf(candidateSlide))

    for listener in @listeners.timechange
      listener(currentTime)

    return

  # Utility function that looks up a proper video plugin for the given video
  findVideoPlugin = (presentz, video) ->
    return presentz.availableVideoPlugins[video._plugin_id] if video._plugin_id? and presentz.availableVideoPlugins[video._plugin_id]?

    plugins = (plugin for plugin in presentz.videoPlugins when plugin.handle(video))
    return plugins[0] if plugins.length > 0
    return presentz.defaultVideoPlugin

  # Utility function that looks up a proper slide plugin for the given slide
  findSlidePlugin = (presentz, slide) ->
    return presentz.availableSlidePlugins[slide._plugin_id] if slide._plugin_id? and presentz.availableSlidePlugins[slide._plugin_id]?

    plugins = (plugin for plugin in presentz.slidePlugins when plugin.handle(slide))
    return plugins[0] if plugins.length > 0
    return presentz.defaultSlidePlugin

  # Sets the synchronized state of presentz, that is: if the slides have to be in synch with the video or not
  synchronized: (@isSynchronized) ->
    @stopTimeChecker() if @intervalSet and !@isSynchronized
    @startTimeChecker() if !@intervalSet and @isSynchronized and !@isPaused()

  # Starts polling the current time to check if a slide change has to occur
  startTimeChecker: () ->
    return unless @isSynchronized

    clearInterval(@interval)
    @intervalSet = true
    timeChecker = () =>
      plugin = @presentation.chapters[@currentChapterIndex].video._plugin
      if plugin instanceof SambatechPlugin
        clazz = @
        plugin.player.getStatus (p) ->
          clazz.checkSlideChange(p.status.time) if clazz.currentChapterIndex isnt -1
      else
        @checkSlideChange(@presentation.chapters[@currentChapterIndex].video._plugin.currentTime()) if @currentChapterIndex isnt -1
      return
    @interval = setInterval(timeChecker, 500)
    return

  # Stops polling the current time 
  stopTimeChecker: () ->
    clearInterval(@interval)
    @intervalSet = false
    return

  # Utility function to create new DOM element IDs
  newElementName: (prefix) ->
    if prefix?
      "#{prefix}_#{Math.round(Math.random() * 1000000)}"
    else
      "element_#{Math.round(Math.random() * 1000000)}"

  # Pauses the presentation
  pause: () ->
    @presentation.chapters[@currentChapterIndex].video._plugin.pause() if @currentChapterIndex isnt -1

  # Returns true if the presentation is paused
  isPaused: () ->
    @presentation.chapters[@currentChapterIndex].video._plugin.isPaused() if @currentChapterIndex isnt -1

  # Starts/resume the presentation
  play: () ->
    @presentation.chapters[@currentChapterIndex].video._plugin.play() if @currentChapterIndex isnt -1

  # Move the video to the next slide. Notice that some video plugins may refuse to react (due to buffering issues)
  next: () ->
    if @presentation.chapters[@currentChapterIndex].slides.length > @currentSlideIndex + 1
      @changeChapter @currentChapterIndex, @currentSlideIndex + 1, true
      return true
    if @presentation.chapters.length > @currentChapterIndex + 1
      @changeChapter @currentChapterIndex + 1, 0, true
      return true
    return false

  # Move the video to the previous slide. Notice that some video plugins may refuse to react (due to buffering issues)
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
