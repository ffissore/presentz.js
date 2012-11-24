assert = require "assert"
SlideShare = require("../src/SlideShare").presentz.SlideShare
SlideShareOEmbed = require("../src/SlideShareOEmbed").presentz.SlideShareOEmbed

fake_presentz =
  newElementName: () -> ""

describe "SlideShare URL parsing", () ->
  slideshare = null
  slideshareoembed = null

  beforeEach () ->
    slideshare = new SlideShare(fake_presentz)
    slideshareoembed = new SlideShareOEmbed(fake_presentz)

  it "should handle valid URLs", () ->
    assert(slideshare.handle({ url: "http://www.slideshare.net/talkcodemotionv4arduino-120623032621-phpapp01#1" }))

  it "should extract slideshare id", () ->
    assert.equal(slideshare.slideId({ url: "http://www.slideshare.net/talkcodemotionv4arduino-120623032621-phpapp01#1" }), "talkcodemotionv4arduino-120623032621-phpapp01")

  it "should extract slideshare number", () ->
    assert.equal(slideshare.slideNumber({ url: "http://www.slideshare.net/talkcodemotionv4arduino-120623032621-phpapp01#1" }), "1")

  it "should get image url", () ->
    slide = { url: "http://www.slideshare.net/slides-110818145820-phpapp02#1", public_url: "http://www.slideshare.net/federicofissore/presentz-demo-slides" }

    #fake prefetch
    slideshareoembed.slideInfo[slide.public_url] =
      conversion_version: 2
      slide_image_baseurl_suffix: "-728.jpg"
      slide_image_baseurl: "//image.slidesharecdn.com/slides-110818145820-phpapp02/85/slide-"

    assert.equal(slideshareoembed.urlOfSlide(slide), "//image.slidesharecdn.com/slides-110818145820-phpapp02/85/slide-1-728.jpg")
