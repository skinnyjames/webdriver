# webdriver

[![Build Status](http://drone.skinnyjames.net/api/badges/skinnyjames/webdriver/status.svg?ref=refs/heads/wip)](http://drone.skinnyjames.net/skinnyjames/webdriver)

[API Documentation](https://skinnyjames.gitlab.io/webdriver)

Implementation of a W3C compliant Webdriver client in Crystal, inspired by Watir

## Why Selenium + Crystal?

When doing e2e testing, it is often advantageous to perform arrangement on the server by
interacting with databases and apis.  This library captializes on crystal's strengths by delivering a Watir like solution to 
interact with w3c compliant browsers in your e2e tests.

webdriver is in beta, feature requests are welcome and appreciated.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     webdriver:
       gitlab: skinnyjames/webdriver
   ```

2. Run `shards install`

## Basic Usage

for more advanced usage, see the wiki and the api documentation

```crystal
require "webdriver"

browser = Webdriver::Browser.start :chrome
browser.goto "https://www.google.com"

search = browser.text_field(title: /search/i)
search.set("Crystal lang webdriver")
search.blur
browser.inputs(aria_label: /Google Search/)[1].wait_until(&.click)

browser.quit
```

## Development

currently in beta


## Todo
### Webdriver protocol
* [x] session
* [x] navigation
* [x] windows
  * [x] window actions
  * [x] window sizing
  * [x] frames 
* [x] elements
* [ ] shadow dom
* [X] document
* [X] cookies
* [x] actions
* [X] user prompts
* [X] screen capture
* [X] print

### Browsers
* [x] chrome
* [x] firefox

## Contributing

1. Fork it (<https://gitlab.com/skinnyjames/webdriver/-/forks/new>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Sean Gregory](https://gitlab.com/skinnyjames) - creator and maintainer
