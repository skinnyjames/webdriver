require "./src/selenium_webdriver/server"

browser = SeleniumWebdriver::Browser.start :chrome

browser.goto "http://www.google.com"
div = browser.div(class: /gb_pa/)
div.a(class: /gb_f/).wait_until(&.click!)
