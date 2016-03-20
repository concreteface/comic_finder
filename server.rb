require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'pg'
require_relative 'app/lib/get_titles_urls'
require_relative 'app/lib/validator'
require_relative 'app/lib/order'
include GetInfo
include Validator
include Order

set :views, File.join(File.dirname(__FILE__), "app", "views")

configure :development do
  set :db_config, { dbname: "comics_development" }
end

# configure :test do
#   set :db_config, { dbname: "comics_finder_test" }
# end

configure :production do
  uri = URI.parse(ENV["DATABASE_URL"])
  set :db_config, {
    host: uri.host,
    port: uri.port,
    dbname: uri.path.delete('/'),
    user: uri.user,
    password: uri.password
  }
end

def db_connection
  begin
    connection = PG.connect(settings.db_config)
    yield(connection)
    ensure
    connection.close
  end
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