module Webdriver
  module Dom
    module BrowserScrollable
      def scroll_to(position : Symbol = :center, force : Bool = false)
        execute_script browser_scroll(position)
        self
      end

      private def browser_scroll(position)
        case position
        when :top, :start
          "window.scrollTo(0, 0);"
        when :center
          "window.scrollTo(window.outerWidth / 2, window.outerHeight / 2);"
        when :bottom, :end
          "window.scrollTo(0, document.body.scrollHeight);"
        end
      end
    end

    module ElementScrollable
      def scroll_to(position : Symbol = :center, force : Bool = false)
        execute_script element_scroll(position), { Webdriver::ELEMENT_KEY => locate_or_throw_error(force)}
        self
      end

      private def element_scroll(position)
        js = case position
        when :top, :start
          "arguments[0].scrollIntoView();"
        when :center
          <<-JS
            const REGEXP_SCROLL_PARENT = /^(visible|hidden)/

            var getScrollParent = el =>
              !(el instanceof HTMLElement) || typeof window.getComputedStyle !== 'function'
                ? null
                : el.scrollHeight >= el.clientHeight && !REGEXP_SCROLL_PARENT.test(window.getComputedStyle(el).overflowY || 'visible')
                  ? el
                  : getScrollParent(el.parentElement) || document.body

            var parent = getScrollParent(arguments[0])
            var bodyRect = parent.getBoundingClientRect()
            var elementRect = arguments[0].getBoundingClientRect();
            var left = (elementRect.left - bodyRect.left) - (window.innerWidth / 2);
            var top = ((elementRect.top - bodyRect.top) - (window.innerHeight / 2))          
            parent.scrollTo(left, top);
          JS
        when :bottom, :end
          "arguments[0].scrollIntoView(false);"
        else
          return nil
        end
      end
    end
  end
end
