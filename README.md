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
    },
    {
      "title": "Part 2",
      "duration": 7,
      "video": {
        "url": "http://presentz.org/assets/demo/demo2.webm"
      },
      "slides": [
        {
          "url": "http://presentz.org/assets/demo/slide5.png",
          "time": 0
        }
      ]
    }
  ]
}
```
