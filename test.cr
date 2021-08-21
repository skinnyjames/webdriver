require "./src/selenium_webdriver/server"

browser2 = SeleniumWebdriver::Server.start
browser2.goto "http://www.yahoo.com"
puts browser2.title

browser2.goto "http://instagram.com"
puts browser2.url

browser2.back
browser2.forward
browser2.refresh