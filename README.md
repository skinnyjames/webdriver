# selenium_webdriver

Implementation of Selenium Webdriver Protocol in Crystal, inspired by Watir

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     selenium_webdriver:
       github: skinnyjames/selenium_webdriver
   ```

2. Run `shards install`

## Usage

```crystal
require "selenium_webdriver"

browser = SeleniumWebdriver::Browser.start :chrome
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
* [ ] windows
  * [x] window actions
  * [x] window sizing
  * [ ] frames 
* [ ] elements
* [ ] document
* [ ] cookies
* [ ] actions
* [ ] user prompts
* [ ] screen capture

### Browsers
* [ ] chrome
* [ ] firefox

## Contributing

1. Fork it (<https://github.com/skinnyjames/selenium_webdriver/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Sean Gregory](https://github.com/skinnyjames) - creator and maintainer
