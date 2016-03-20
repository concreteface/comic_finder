require 'httparty'
require 'nokogiri'

class ComicList
  attr_accessor :date
  attr_reader :base_url

  def initialize(date)
    @date = Date.parse(date)
    @base_url='http://comicbookroundup.com'
    @page = HTTParty.get("#{@base_url}/comic-books/release-dates/#{@date}")
    @parsed_page = Nokogiri::HTML(@page)
    parse_pages
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

  def parse_pages
    @pages = []
    find_urls.each do |u|
      @pages <<  HTTParty.get("#{@base_url}#{u}")
    end
    @pages
  end

  def cover_url(title_index)
    # cover_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_cover = Nokogiri::HTML(@pages[title_index])
    cover_half = parsed_cover.css('img[@title]/@src')
    "#{@base_url}#{cover_half}"
  end

  def writer(title_index)
    # writer_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_writer = Nokogiri::HTML(@pages[title_index])
    if parsed_writer.css("//[@class='left']/span[4]/a/text()").to_s == '' && parsed_writer.css("//[@class='left']/span[3]/a/text()").to_s == ''
      writer = 'N/A'
    else writer = joiner(parsed_writer.css("//[@class='left']/span[1]/a/text()"))
    end
    writer
  end

  def artist(title_index)
    # artist_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_artist = Nokogiri::HTML(@pages[title_index])
    if parsed_artist.css("//[@class='left']/span[4]/a/text()").to_s == ''
      if parsed_artist.css("//[@class='left']/span[3]/a/text()").to_s == ''
        artist = 'N/A'
      else
        artist = joiner(parsed_artist.css("//[@class='left']/span[1]/a/text()"))
      end
    else artist = joiner(parsed_artist.css("//[@class='left']/span[2]/a/text()"))
    end
    artist
  end

  def publisher(title_index)
    # publisher_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_publisher = Nokogiri::HTML(@pages[title_index])
    if parsed_publisher.css("//[@class='left']/span[4]/a/text()").to_s == ''
      if parsed_publisher.css("//[@class='left']/span[3]/a/text()").to_s == ''
        pub = parsed_publisher.css("//[@class='left']/span[1]/a/text()")
      else
        pub = parsed_publisher.css("//[@class='left']/span[2]/a/text()")
      end
    else pub = parsed_publisher.css("//[@class='left']/span[3]/a/text()")
    end
    pub
  end

  def description(title_index)
    # description_page = HTTParty.get("#{@base_url}#{half_url}")
    parsed_description = Nokogiri::HTML(@pages[title_index])
    if parsed_description.css("//[@class='clear']/[@itemprop]/text()").length == 0
      desc = parsed_description.css("//[@class='clear']/text()")
    else desc = parsed_description.css("//[@class='clear']/[@itemprop]/text()")
    end
    desc
  end

  def joiner(nodeset)
    unjoined = []
    nodeset.each do |w|
      unjoined << w
    end
    joined = unjoined.join(', ')
  end

end


# date = Date.parse('mar 2nd 2016')
# # cl = ComicList.new("#{date.year}-#{date.month}-#{date.day}")
# cl = ComicList.new('mar 2nd 2016')
# # ComicList.cover_url('/comic-books/reviews/vertigo/clean-room/5')
# puts cl.writer(1)
# puts HTTParty.get("#{cl.base_url}#{cl.find_urls[0]}")
# puts cl.parse_page[0]
# array = []
# cl.find_urls.each do |u|
#   array << HTTParty.get("#{cl.base_url}#{u}")
# end
# puts array[0]
