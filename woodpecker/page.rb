require 'hpricot'
require 'open-uri'

module WoodPecker
  class Page
    def initialize(url)
      @url = url
      @doc = open(url) {|f| Hpricot(f)}
    end

    def preprocess
      append_base_tag
      append_javascript_tag("//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js")
      append_javascript_tag("http://0.0.0.0:9393/assets/all.js")
      append_stylesheet_tag("http://0.0.0.0:9393/assets/all.css")
    end

    def html
      @doc.inner_html
    end

    private

    def headers
      @doc.search("//head")
    end

    def append_base_tag
      headers.append("<base href='#{@url}' />")
    end

    def append_javascript_tag(src)
      headers.append("<script src='#{src}' type='text/javascript'></script>")
    end

    def append_stylesheet_tag(src)
      headers.append("<link rel='stylesheet' type='text/css' href='#{src}' />")
    end
  end
end