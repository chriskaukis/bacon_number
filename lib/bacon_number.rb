require "bacon_number/version"

require 'nokogiri'
require 'open-uri'
require 'uri'

module BaconNumber
  KEVIN_BACON = 'https://en.wikipedia.org/wiki/Kevin_Bacon'

  def self.separations(src, tgt = KEVIN_BACON)
    page = BaconNumber::Page.new(src)
    return page if src == tgt
    queue = [page]
    visited = { page.url.to_s => page }
    while !queue.empty?
      item = queue.shift
      item.children.each do |child|
        next if visited[child.url.to_s]
        # return child if child.url.to_s == tgt
        return { separations: child.separations, via: child.parent.url.to_s } if child.url.to_s == tgt
        queue << child
        visited[child.url.to_s] = child
      end
    end
    nil
  end

  class Page
    attr_accessor :url, :separations, :parent

    def initialize(url, parent = nil, separations = 0)
      self.url = URI.parse(url)
      self.separations = separations
      self.parent = parent
    end

    # links returns the unique internal links at this pages URL or tries to.
    def children
      return @children if defined?(@children)

      @children = []
      html.css("a[href]").each do |link|
        begin
          href = URI.parse(link['href'])
        rescue URI::InvalidURIError
          next
        else
          if href.relative?
            href.scheme = self.url.scheme
            href.host = self.url.host
          end
          # href.query = nil
          href.fragment = nil
          # next unless href.host == 'en.wikipedia.org'
          next unless href.host == self.url.host
          page = BaconNumber::Page.new(href.to_s, self, separations + 1)
          @children << page unless @children.include?(page)
        end
      end
      @children
    end

    def children_hash
      return @children_hash if defined?(@children_hash)

      @children_hash = {}
      children.each do |child|
        @children_hash[child.url.to_s] = child
      end
      @children_hash
    end

    def ==(value)
      url.to_s == value.url.to_s
    end

    private

    def html
      @html ||= Nokogiri::HTML(open(url))
    end
  end
end
