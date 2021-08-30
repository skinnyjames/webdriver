require "./src/selenium_webdriver/server"

browser = SeleniumWebdriver::Browser.start :chrome

browser.goto "http://www.google.com"
div = browser.div(class: /gb_pa/)
div.a(class: /gb_f/).wait_until(&.click!)

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