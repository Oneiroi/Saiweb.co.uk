#
# Author: Brandon Mathis
# A full rewrite based on the work of: Josediaz Gonzalez - https://github.com/josegonzalez/josediazgonzalez.com/blob/master/_plugins/blockquote.rb
#
# Outputs a string with a given attribution as a quote
#
#   {% blockquote Bobby Willis http://google.com/search?q=pants the search for bobby's pants %}
#   Wheeee!
#   {% endblockquote %}
#   ...
#   <blockquote>
#     <p>Wheeee!</p>
#     <footer>
#     <strong>Bobby Willis</strong><cite><a href="http://google.com/search?q=pants">The Search For Bobby's Pants</a>
#   </blockquote>
#
require './plugins/titlecase.rb'

module Jekyll

  class Blockquote < Liquid::Block
    FullCiteWithTitle = /(\S.*)\s+(https?:\/\/)(\S+)\s+(.+)/i
    FullCite = /(\S.*)\s+(https?:\/\/)(\S+)/i
    AuthorTitle = /([^,]+),([^,]+)/
    Author =  /(.+)/

    def initialize(tag_name, markup, tokens)
      @by = nil
      @source = nil
      @title = nil
      if markup =~ FullCiteWithTitle
        @by = $1
        @source = $2 + $3
        @title = $4.titlecase.strip
      elsif markup =~ FullCite
        @by = $1
        @source = $2 + $3
      elsif markup =~ AuthorTitle
        @by = $1
        @title = $2.titlecase.strip
      elsif markup =~ Author
        @by = $1
      end
      super
    end

    def render(context)
      quote = paragraphize(super.map(&:strip).join)
      quote = paragraphize(super)
      author = "<strong>#{@by.strip}</strong>" if @by
      if @source
        url = @source.match(/https?:\/\/(.+)/)[1].split('/')
        parts = []
        url.each do |part|
          if (parts + [part]).join('/').length < 32
            parts << part
          end
        end
        source = parts.join('/')
        source << '/&hellip;' unless source == @source
      end
      if !@source.nil?
        cite = " <cite><a href='#{@source}'>#{(@title || source)}</a></cite>"
      elsif !@title.nil?
        cite = " <cite>#{@title}</cite>"
      end
      blockquote = if @by.nil?
        quote
      elsif cite
        "#{quote}<footer>#{author + cite}</footer>"
      else
        "#{quote}<footer>#{author}</footer>"
      end
      "<blockquote>#{blockquote}</blockquote>"
    end

    def paragraphize(input)
      "<p>#{input.gsub(/\n\n/, '</p><p>').gsub(/\n/, '<br/>')}</p>"
      "<p>#{input.lstrip.rstrip.gsub(/\n\n/, '</p><p>').gsub(/\n/, '<br/>')}</p>"
    end
  end
end

Liquid::Template.register_tag('blockquote', Jekyll::Blockquote)
