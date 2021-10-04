module Webdriver
  module Commands
    module Document
      def get_page_source
        make_get_request("source")
      end

      def execute_script(body, *arguments)
        make_post_request("execute/sync", { script: body, args: arguments || [] of String })
      end

      def execute_script_async(body, *arguments)
        make_post_request("execute/async", { script: body, args: arguments || [] of String })
      end
    end
  end
end
