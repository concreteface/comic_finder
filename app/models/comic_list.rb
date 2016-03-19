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
    @parsed_page.xpath("//td[@class='title']/a/text()").each do |title|
      titles << title
    end
    titles
  end

  def find_urls
    urls = []
    @parsed_page.xpath("//td[@class='title']/a/@href").each do |url|
      urls << url
    end
    urls
  end

  def cover_url(half_url)
    cover_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_cover = Nokogiri::HTML(cover_page)
    cover_half = parsed_cover.css('img[@title]/@src')
    "#{@base_url}#{cover_half}"
  end
end

# cl = ComicList.new('mar 16 2016')
# # ComicList.cover_url('/comic-books/reviews/vertigo/clean-room/5')
# puts cl.find_titles[32]
# puts cl.cover_url(cl.find_urls[32])