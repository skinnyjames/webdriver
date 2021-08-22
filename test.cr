require "./src/selenium_webdriver/server"

browser = SeleniumWebdriver::Server.start
first_window = browser.windows[0]
browser.goto "http://www.google.com"
window = browser.windows.new
third_window = browser.windows.new
browser.use(window)
browser.goto "https://www.yahoo.com"
browser.use(third_window)
browser.goto "https://www.facebook.com"
browser.close(third_window)
browser.close(first_window)
browser.close(window)






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