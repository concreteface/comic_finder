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
  if !params[:date].nil?
    @message = ''
    if Date.parse(params[:date]).wednesday?
      @date = Date.parse(params[:date])
      @list = ComicList.new(params[:date])
      @titles = @list.find_titles
      @urls = @list.find_urls
      @message = 'Here are the comics released on the day you requested.'
      @titles.each_with_index do |t, i|
        Issue.create(title: t, image_url: @list.cover_url(@urls[i]), release_date: @date)
      end
      @issues = Issue.where(release_date: @date)
      # binding.pry
    else @message = "That's not a wednesday"
    end
  end
  erb :index
end

get '/issues/:id' do
  @issue = Issue.find(params[:id])
  erb :show
end
