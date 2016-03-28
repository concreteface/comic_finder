require 'httparty'
require 'nokogiri'

class ComicList
  attr_accessor :date
  attr_reader :base_url, :pages

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

  def publishers
    urls =  @parsed_page.xpath("//td[@class='title']/a/@href").to_s.split('/comic-books/')
    urls.shift
    withdash = []
    urls.each do |u|
      u.gsub!('trades/reviews/', '')
      if u.include?('reviews/')
        u.gsub!('reviews/', '')
      end
      withdash << u.split('/')[0]
    end
    publishers = []
    withdash.each do |str|
      publishers << str.gsub('-', ' ').split.map(&:capitalize).join(' ')
    end
    publishers
  end

end


# date = Date.parse('jan 27 2016')
# # cl = ComicList.new("#{date.year}-#{date.month}-#{date.day}")
# cl = ComicList.new('2016-03-23')
# # # ComicList.cover_url('/comic-books/reviews/vertigo/clean-room/5')
# puts cl.publishers.length
# puts cl.artist(cl.pages[42])
