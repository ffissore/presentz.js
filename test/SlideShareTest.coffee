assert = require "assert"
SlideShare = require("../src/SlideShare").presentz.SlideShare

fake_presentz =
  newElementName: () -> ""

describe "SlideShare URL parsing", () ->
  slide = null

  beforeEach () ->
    slide = new SlideShare(fake_presentz)

  it "should handle valid URLs", () ->
    assert(slide.handle({ url: "http://www.slideshare.net/talkcodemotionv4arduino-120623032621-phpapp01#1" }))

  it "should extract slide id", () ->
    assert.equal(slide.slideId({ url: "http://www.slideshare.net/talkcodemotionv4arduino-120623032621-phpapp01#1" }), "talkcodemotionv4arduino-120623032621-phpapp01")

  it "should extract slide number", () ->
    assert.equal(slide.slideNumber({ url: "http://www.slideshare.net/talkcodemotionv4arduino-120623032621-phpapp01#1" }), "1")
