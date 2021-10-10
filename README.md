# webdriver

[![Build Status](http://drone.skinnyjames.net/api/badges/skinnyjames/webdriver/status.svg)](http://drone.skinnyjames.net/skinnyjames/webdriver)

[API Documentation](https://skinnyjames.github.io/webdriver/index.html)

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
       github: skinnyjames/webdriver
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

currently in wip


## Todo
### Webdriver protocol
* [x] session
* [x] navigation
* [/] windows
  * [x] window actions
  * [x] window sizing
  * [ ] frames 
* [/] elements
* [X] document
* [X] cookies
* [ ] actions
* [X] user prompts
* [X] screen capture
* [X] print

### Browsers
* [/] chrome
* [/] firefox

## Contributing

1. Fork it (<https://github.com/skinnyjames/webdriver/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Sean Gregory](https://github.com/skinnyjames) - creator and maintainer
