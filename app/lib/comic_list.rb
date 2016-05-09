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
      pre = str.gsub('-', ' ').split.map(&:capitalize).join(' ')
      if pre == 'Dc Comics'
        pre = 'DC Comics'
      end
      if pre == 'Idw Publishing'
        pre = 'IDW Publishing'
      end
      publishers << pre
    end
    publishers
  end
end

# list = ComicList.new('2016-04-06')
# puts list.find_titles
# s
