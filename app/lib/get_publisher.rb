class GetPublisher




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
end