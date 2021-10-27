module Webdriver
  module Dom
    module Presence
      def exists?(force : Bool = false)
        begin
          locate_or_throw_error(force)
          true
        rescue Command::ElementNotFoundException 
          false
        end
      end

      def present?(force : Bool = false)
        exists?(force: force) && displayed?(force: force)
      end

      def displayed?(force : Bool = false)
        server.command.is_element_displayed locate_or_throw_error(force)
      end

      def obscured?
        js = <<-JS
          function() {
            var elem = arguments[0],
                box = elem.getBoundingClientRect(),
                cx = box.left + box.width / 2,
                cy = box.top + box.height / 2,
                e = document.elementFromPoint(cx, cy);
              for (; e; e = e.parentElement) {
                  if (e === elem)
                      return false;
              }
              return true;
          }
        JS
        execute_script js, { Webdriver::ELEMENT_KEY => locate_or_throw_error(force)}
      end
    end
  end
end