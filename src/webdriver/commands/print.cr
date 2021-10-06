module Webdriver
  module Commands
    module Print
      def print(
        orientation : String = "portrait", 
        scale : Int32 = 1,
        background : Bool = false,
        width : Float = 21.59,
        height : Float = 27.94,
        top : Int32 = 1,
        bottom : Int32 = 1,
        left : Int32 = 1,
        right : Int32 = 1,
        shrink : Bool = true,
        ranges : Array(Int32) = [] of Int32
      )
        make_post_request("print", {
          orientation: orientation,
          scale: scale,
          background: background,
          page: { 
            pageWidth: width, 
            pageHeight: height 
          },
          margin: { 
            marginTop: top, 
            marginBottom: bottom, 
            marginLeft: left, 
            marginRight: right 
          },
          shrinkToFit: shrink,
          pageRanges: ranges
        })
      end
    end
  end
end
