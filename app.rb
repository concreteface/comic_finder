require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'

configure :development, :test do
  require 'pry'
end

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
  also_reload file
end

get '/' do
  redirect '/issues'
end

get '/issues' do
  if !params[:date].nil? && params[:date] != ''
    @message = ''
    @date = Date.parse(params[:date])
    # if @date.wednesday?
      get_titles_urls(@date)
      # if !Issue.exists?(release_date: @date)
      if Issue.group(:release_date).count[@date] != @titles.length
        @titles.each_with_index do |t, i|
          # if i > @titles.length - 1
            Issue.create(title: t, image_url: @list.cover_url(@urls[i]), release_date: @date, writers: @list.writer(@urls[i]), artist: @list.artist(@urls[i]), description: @list.description(@urls[i]), publisher: @list.publisher(@urls[i]))
          # end
        end
      end
      @message = "Here are the comics released on #{@date.month}/#{@date.day}/#{@date.year}."
    # else @message = "That's not a wednesday."
    # end
  end
  @issues = Issue.where(release_date: @date).order(:title)
  erb :index
end

get '/issues/:id' do
  @issue = Issue.find(params[:id])
  erb :show
end

def get_titles_urls(date)
  @list = ComicList.new("#{date.year}-#{date.month}-#{date.day}")
  @titles = @list.find_titles
  @urls = @list.find_urls
end
