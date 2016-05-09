require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'pg'
require_relative 'app/lib/get_titles_urls'
require_relative 'app/lib/validator'
require_relative 'app/lib/order'
require_relative 'app/lib/issue_updater'
require_relative 'app/lib/next_wednesday'
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
  if params[:recent] && params[:recent] == 'next'
    @date = Wednesday.date_of_next
    lister(@date)
  elsif params[:recent] && params[:recent] == 'last'
    @date = Wednesday.date_of_last
    lister(@date)
  elsif validator(params[:date])
    @message = ''
    @date = Date.parse(params[:date])
    lister(@date)
  else @message = "Please enter a valid date"
  end
  @issues = Issue.where(release_date: @date).order(order(params))
  ActiveRecord::Base.clear_active_connections!
  erb :index
end

get '/issues/:id' do
  @issue = Issue.find(params[:id])
  @date = @issue.release_date
  @updater = IssueUpdater.new(params[:id])
  if @issue.image_url.nil? || @issue.image_url == "http://comicbookroundup.com" || @issue.image_url.include?('comhttp')
    @issue.update(writers: @updater.writerupdate, artist: @updater.artistupdate, description: @updater.descriptionupdate, image_url: @updater.cover_urlupdate)
  end
  ActiveRecord::Base.clear_active_connections!
  erb :show
end

def lister(date)
  get_titles_urls(@date)
  @titles.each_with_index do |t, i|
    Issue.create(title: t, info_url: @list.find_urls[i], release_date: @date, publisher: @list.publishers[i])
  end
  @message = "Here are the comics released on #{@date.month}/#{@date.day}/#{@date.year}."
end
