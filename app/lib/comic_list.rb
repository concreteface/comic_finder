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

  def writer(half_url)
    writer_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_writer = Nokogiri::HTML(writer_page)
    parsed_writer.css("//[@class='left']/span[1]/a/text()")
  end

  def artist(half_url)
    artist_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_artist = Nokogiri::HTML(artist_page)
    parsed_artist.css("//[@class='left']/span[2]/a/text()")
  end

  def publisher(half_url)
    publisher_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_publisher = Nokogiri::HTML(publisher_page)
    parsed_publisher.css("//[@class='left']/span[3]/a/text()")
  end

  def description(half_url)
    description_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_description = Nokogiri::HTML(description_page)
    parsed_description.css("//[@class='clear']/[@itemprop]/text()")
  end

end


# date = Date.parse('mar 2nd 2016')
# # cl = ComicList.new("#{date.year}-#{date.month}-#{date.day}")
# cl = ComicList.new('mar 2nd 2016')
# # ComicList.cover_url('/comic-books/reviews/vertigo/clean-room/5')
# url = cl.find_urls[3]

# puts cl.artist(url).class