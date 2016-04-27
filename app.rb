require 'sinatra'
require 'sinatra/multi_route'
require 'sinatra/reloader' if development?

# use Rack::Auth::Basic, 'Protected Area' do |username, password|
#   username == 'foo' && password == 'bar'
# end

before do
  # TODO sane defaults
  @page = OpenStruct.new(
    url: request.url,
    og: OpenStruct.new(
      image: 'http://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/2X/0/0e4226eef7e5800a9c0b63ccb3ec41d5a5f5b2c0.png',
      secure_url: 'https://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/2X/0/0e4226eef7e5800a9c0b63ccb3ec41d5a5f5b2c0.png'
    )
  )
end

get '/' do
  erb :index
end

get '/o-nas/?' do
  @page.title = 'O nás'
  erb :about
end

get '/aktuality/?' do
  @page.title = 'Aktuality'
  erb :news
end

get '/temy/?' do
  @page.title = 'Na čom pracujeme?'
  erb :topics
end

get '/pre-media/?' do
  @page.title = 'Pre médiá'
  erb :press
end

get '/podporovatelia/?' do
  @page.title = 'Podporovatelia'
  erb :supporters
end

get '/stanovy/?' do
  @page.title = 'Stanovy'
  erb :rules
end

get '/eticky-kodex/?' do
  @page.title = 'Etický kódex'
  erb :codex
end

get '/podpora/?' do
  @page.title = 'Zapojte sa'
  @page.og.title = 'Aj ja podporujem boj za lepšie digitálne služby štátu!'
  @page.og.image = 'https://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/2X/7/72285cc13f501538bc29afe57000e2f9ac2f210f.jpg'
  @page.og.secure_url = 'https://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/2X/7/72285cc13f501538bc29afe57000e2f9ac2f210f.jpg'

  erb :contribute
end

route :get, :post, '/dakujeme/?' do
  @page.title = 'Ďakujeme'
  @params = params
  erb :thanks
end

get '/venujte-svoj-cas/?' do
  @page.title = 'Venujte svoj čas'
  erb :collaborate
end

get '/kontakt/?' do
  @body_class = 'main'
  @page.title = 'Kontakt'
  erb :contact
end


get '/vyzva/?' do
  @page.og = OpenStruct.new(
    title: 'Informatizácia na Slovensku má veľký problém.',
    description: 'Slovensko od roku 2007 minulo na informatizáciu 900 miliónov eur. Úradníkom však stále robíme poštára a veľa sa nezmenilo.',
    image: 'http://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/1X/5df787dcf909f2ddc62132853e33f2def7ee15d3.jpg',
    secure_url: 'https://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/1X/5df787dcf909f2ddc62132853e33f2def7ee15d3.jpg',
  )

  erb :'vyzva/index', layout: :'vyzva/layout'
end

get '/vyzva/style.css' do
  scss :'vyzva/style'
end
