require "./src/selenium_webdriver/server"

browser = SeleniumWebdriver::Browser.start :chrome

first_window = browser.windows[0]
browser.goto "http://www.google.com"
browser.element(title: /earc/).locate









# window = browser2.windows.new
# window.use
# browser.goto "http://www.yahoo.com"
# puts browser2.title
# browser.close(window)

# browser2.goto "http://instagram.com"
# puts browser2.url

# browser2.back
# browser2.forward
# browser2.refresh
# puts window