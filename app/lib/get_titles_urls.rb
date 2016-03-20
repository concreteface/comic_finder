module GetInfo
  def get_titles_urls(date)
    @list = ComicList.new("#{date.year}-#{date.month}-#{date.day}")
    @titles = @list.find_titles
    # @urls = @list.find_urls
  end
end
