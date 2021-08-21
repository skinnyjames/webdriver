require "./src/selenium_webdriver/server"

browser = SeleniumWebdriver::Server.start
browser.goto "http://www.google.com"