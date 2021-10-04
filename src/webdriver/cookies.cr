module Webdriver
  class Cookie
    def initialize(@cookie_data : Hash(String, JSON::Any))
    end

    def name
      @cookie_data["name"].as_s
    end
  end
  
  module Cookies
    def cookies
      payloads = server.command.get_all_cookies
      payloads.as_a.map do |cookie_data|
        Cookie.new(cookie_data.as_h)
      end
    end

    def delete_cookie(cookie : Webdriver::Cookie)
      server.command.delete_cookie(cookie.name)
    end

    def delete_cookie(name : String)
      server.command.delete_cookie(name)
    end

    def add_cookie(**opts)
      server.command.add_cookie(**opts)
    end
    
    def add_cookie(cookie : HTTP::Cookie)
      server.command.add_cookie(cookie)
    end

    def add_cookies(cookies : Array(HTTP::Cookie))
      server.command.add_cookies(cookies)
    end

    def delete_all_cookies
      server.command.delete_all_cookies
    end
  end
end
