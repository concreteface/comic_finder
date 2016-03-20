require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require_relative 'app/lib/get_titles_urls'
require_relative 'app/lib/validator'
require_relative 'app/lib/order'
include GetInfo
include Validator
include Order

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
  if validator(params[:date])
    @message = ''
    @date = Date.parse(params[:date])
    get_titles_urls(@date)
    if Issue.group(:release_date).count[@date] != @titles.length
      @titles.each_with_index do |t, i|
        Issue.create(title: t, image_url: @list.cover_url(@urls[i]), release_date: @date, writers: @list.writer(@urls[i]), artist: @list.artist(@urls[i]), description: @list.description(@urls[i]), publisher: @list.publisher(@urls[i]))
      end
    end
    @message = "Here are the comics released on #{@date.month}/#{@date.day}/#{@date.year}."
  else @message = "Please enter a valid date"
  end
  @issues = Issue.where(release_date: @date).order(order(params))
  erb :index
end

get '/issues/:id' do
  @issue = Issue.find(params[:id])
  erb :show
end