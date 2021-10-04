module Webdriver
  module Commands
    module Cookies
      def get_all_cookies
        make_get_request("cookie")
      end

      def get_named_cookie(name)
        make_get_request("cookie/#{name}")
      end

      def delete_cookie(name)
        make_delete_request("cookie/#{name}")
      end

      def delete_all_cookies
        make_delete_request("cookie")
      end

      def add_cookie(
        name : String, 
        value : String, 
        path : String = "/", 
        domain : String? = nil,
        secure : Bool = false,
        http_only : Bool = false,
        expires : Time | Int32 | Nil = nil,
        same_site : HTTP::Cookie::SameSite? = nil
      )
        cookie = {
          "name"     => name,
          "value"    => value,
          "path"     => path,
          "domain"   => domain,
          "secure"   => secure,
          "httpOnly" => http_only,
          "expiry"   => expires.is_a?(Time) ? expires.to_unix : expires,
          "sameSite" => same_site.to_s,
        }
        make_post_request("cookie", { cookie: cookie.compact })
      end

      def add_cookie(cookie c : HTTP::Cookie)
        add_cookie(c.name, c.value, c.path, c.domain, c.secure, c.http_only, c.expires, c.same_site)
      end

      def add_cookies(cookies : HTTP::Cookies)
        cookies.each do |cookie|
          add_cookie(cookie)
        end
      end
    end
  end
end