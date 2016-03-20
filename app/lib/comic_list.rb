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

  def parse_pages
    @pages = []
    find_urls.each do |u|
      @pages <<  Nokogiri::HTML(HTTParty.get("#{@base_url}#{u.to_s.encode("ASCII", invalid: :replace, undef: :replace, replace: '')}"))
    end
    @pages
  end

  def cover_url(parsed_page)
    cover_half = parsed_page.css('img[@title]/@src')
    "#{@base_url}#{cover_half}"
  end

  def writer(parsed_page)
    if parsed_page.css("//[@class='left']/span[4]/a/text()").to_s == '' && parsed_page.css("//[@class='left']/span[3]/a/text()").to_s == ''
      writer = 'N/A'
    else writer = joiner(parsed_page.css("//[@class='left']/span[1]/a/text()"))
    end
    writer
  end

  def artist(parsed_page)
    if parsed_page.css("//[@class='left']/span[4]/a/text()").to_s == ''
      if parsed_page.css("//[@class='left']/span[3]/a/text()").to_s == ''
        artist = 'N/A'
      else
        artist = joiner(parsed_page.css("//[@class='left']/span[1]/a/text()"))
      end
    else artist = joiner(parsed_page.css("//[@class='left']/span[2]/a/text()"))
    end
    artist
  end

  def publisher(parsed_page)
    if parsed_page.css("//[@class='left']/span[4]/a/text()").to_s == ''
      if parsed_page.css("//[@class='left']/span[3]/a/text()").to_s == ''
        pub = parsed_page.css("//[@class='left']/span[1]/a/text()")
      else
        pub = parsed_page.css("//[@class='left']/span[2]/a/text()")
      end
    else pub = parsed_page.css("//[@class='left']/span[3]/a/text()")
    end
    pub
  end

  def description(parsed_page)
    if parsed_page.css("//[@class='clear']/[@itemprop]/text()").length == 0
      desc = parsed_page.css("//[@class='clear']/text()")
    else desc = parsed_page.css("//[@class='clear']/[@itemprop]/text()")
    end
    desc.to_s.encode('UTF-8', :invalid => :replace, :undef => :replace)
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
# cl.parse_pages
# puts cl.artist(cl.pages[1])