Presentz.js
=========

Presentz.js is a javascript library for synchronizing videos and slides.

A JSON file
-----------
Presentz.js starts with a presentation, a json object whose structure is

```json
{
  "title": "Video tag, images as slides",
  "chapters": [
    {
      "title": "Part 1",
      "duration": 21,
      "video": {
        "url": "http://presentz.org/assets/demo/demo1.webm",
        "thumb": "http://presentz.org/assets/demo/videotag-img.png"
      },
      "slides": [
        {
          "url": "http://presentz.org/assets/demo/slide1.png",
          "time": 0
        },
        {
          "url": "http://presentz.org/assets/demo/slide2.png",
          "time": 7
        },
        {
          "url": "http://presentz.org/assets/demo/slide3.png",
          "time": 9.5
        },
        {
          "url": "http://presentz.org/assets/demo/slide4.png",
          "time": 14
        }
      ]
    }
  ]
}
```

(A slightly richer version of this presentation can be seen at http://presentz.org/demo/01_videotag-img)

In essence:

- each presentation has a `title` and a list of `chapters`
- each chapter has 
  - a `duration` (expressed in seconds)
  - a `video` with a `url`
  - a list of `slides`
- each slide has a `url` and a `time` (expressed in seconds)

The most important information is the `time` of a slide: it's used to determine when a slidechange has to occur and which slide has to be displayed. Such time is relative to the video of the containing chapter.