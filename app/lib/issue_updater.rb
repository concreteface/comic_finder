class IssueUpdater
  attr_reader :writerupdate, :artistupdate, :publisherupdate, :descriptionupdate, :cover_urlupdate, :parsed_page
  def initialize(id)
    @issue = Issue.find(id)
    @base_url='http://comicbookroundup.com'
    @page = HTTParty.get("#{@base_url}/#{@issue.info_url}")
    @parsed_page = Nokogiri::HTML(@page)
    @writerupdate = writer(@parsed_page)
    @artistupdate = artist(@parsed_page)
    @cover_urlupdate = cover_url(@parsed_page)
    @descriptionupdate = description(@parsed_page)
  end

  def cover_url(parsed_page)
    cover_at = ''
    cover_half = parsed_page.css("//[@class='left']/img/@src")
    if cover_half.to_s.include? 'previewsworld'
      cover_at = cover_half
    else
      cover_at = "#{@base_url}#{cover_half}"
    end
    cover_at
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
