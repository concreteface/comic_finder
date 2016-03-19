require 'httparty'
require 'nokogiri'

class ComicList
  attr_accessor :date

  def initialize(date)
    @date = Date.parse(date)
    @base_url='http://comicbookroundup.com'
    @page = HTTParty.get("#{@base_url}/comic-books/release-dates/#{@date}")
    @parsed_page = Nokogiri::HTML(@page)
  end

  def find_titles
    titles = []
    @parsed_page.css('.title').each do |t|
      titles << t
    end
    joined = titles.join('-').split('-')
    joined.shift
    joined
  end

  def cover_title
    h = {}
    @parsed_page.css('.title').xpath('//a[@href]').each do |link|
      h[link.text.strip] = link['href']
    end
    h.each do |k, v|
      if find_titles.include?(k)
        puts "Key: #{k}, Value: #{v}"
      end
    end
  end

end

cl = ComicList.new('feb 17 2016')
cl.cover_title
