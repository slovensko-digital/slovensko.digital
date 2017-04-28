require 'sinatra'
require 'sinatra/multi_route'
require 'sinatra/reloader' if development?
require 'newrelic_rpm'

before do
  # TODO sane defaults
  @page = OpenStruct.new(
    url: request.url.split('?').first,
    og: OpenStruct.new(
      image: 'http://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/2X/8/81f213b2919f9e7d944d5d00c0150b8406503988.png',
      secure_url: 'https://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/2X/8/81f213b2919f9e7d944d5d00c0150b8406503988.png',
      description: 'Chceme, aby boli digitálne služby štátu boli jednoduché a dávali zmysel.'
    )
  )
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  erb :index
end

get '/co-robime/?' do
  @page.title = 'Čo robíme'
  erb :index
end

get '/o-nas/?' do
  @page.title = 'O nás'
  erb :about
end

get '/kariera/?' do
  @page.title = 'Kariéra'
  erb :career
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
  @page.og.image = 'https://platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/a/a98ccf5b5708c40a6bc605bf56f32d0ae24cab6a.png'
  @page.og.secure_url = 'https://platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/a/a98ccf5b5708c40a6bc605bf56f32d0ae24cab6a.png'
  @page.og.description = 'Robíme všetko preto, aby bolo štátne IT lepšie.'
  erb :contribute
end

route :get, :post, '/dakujeme/?' do
  redirect to('/podpora') unless params['price']
  @page.title = 'Ďakujeme'
  @page.fb_conversion = OpenStruct.new(value: params['price'])
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

get '/narodeniny/?' do
  @page.title = 'Narodeniny'
  @page.og.title = 'Slovensko.Digital oslavuje prvé narodeniny!'
  @page.og.image = 'https://platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/0/02919efd05a9ffa79cd44871309a427f5050fc48.png'
  @page.og.secure_url = 'https://platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/0/02919efd05a9ffa79cd44871309a427f5050fc48.png'
  @page.og.description = 'Už rok sa snažíme o to, aby štátne IT bolo lepšie. Veľa sa nám podarilo a veľa nás ešte čaká. Potrebujeme tvoju pomoc.'
  erb :'birthday/index'
end

get '/narodeniny/kamarati' do
  @page.title = 'Aj ja som Slovensko.Digital'
  @page.og.image = 'https://platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/0/02919efd05a9ffa79cd44871309a427f5050fc48.png'
  @page.og.secure_url = 'https://platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/0/02919efd05a9ffa79cd44871309a427f5050fc48.png'
  erb :'birthday/friends'
end

get '/narodeniny/prihody' do
  @page.title = 'Príhody'
  @page.og.image = 'https://platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/0/02919efd05a9ffa79cd44871309a427f5050fc48.png'
  @page.og.secure_url = 'https://platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/0/02919efd05a9ffa79cd44871309a427f5050fc48.png'
  erb :'birthday/stories'
end

# TODO rm since this was probably moved away and now yields 500
# get '/vyzva/?' do
#   @page.og = OpenStruct.new(
#     title: 'Informatizácia na Slovensku má veľký problém.',
#     description: 'Slovensko od roku 2007 minulo na informatizáciu 900 miliónov eur. Úradníkom však stále robíme poštára a veľa sa nezmenilo.',
#     image: 'http://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/1X/5df787dcf909f2ddc62132853e33f2def7ee15d3.jpg',
#     secure_url: 'https://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/1X/5df787dcf909f2ddc62132853e33f2def7ee15d3.jpg',
#   )
#   erb :'vyzva/index', layout: :'vyzva/layout'
# end
#
# get '/vyzva/style.css' do
#   scss :'vyzva/style'
# end

not_found do
  erb :'404'
end

get '/oz/novinky/?' do
  redirect to('/aktuality')
end
