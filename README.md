# webdriver

[![Build Status](http://drone.skinnyjames.net/api/badges/skinnyjames/webdriver/status.svg)](http://drone.skinnyjames.net/skinnyjames/webdriver)

[API Documentation](https://skinnyjames.github.io/webdriver/index.html)

Implementation of a W3C compliant Webdriver client in Crystal, inspired by Watir

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     webdriver:
       github: skinnyjames/webdriver
   ```

2. Run `shards install`

## Usage

```crystal
require "webdriver"

browser = Webdriver::Browser.start :chrome
browser.goto "https://www.google.com"
browser.url # => https://www.google.com
browser.goto "https://www.yahoo.com"
browser.back
browser.refresh
browser.maximize
window = browser.windows.new
browser.use(window)
browser.close(window)
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
* [ ] print

### Browsers
* [ ] chrome
* [ ] firefox

## Contributing

1. Fork it (<https://github.com/skinnyjames/webdriver/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Sean Gregory](https://github.com/skinnyjames) - creator and maintainer
