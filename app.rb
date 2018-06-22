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

get '/clenstvo' do
  @page.title = 'Členstvo'
  @page.og.image = 'https://slovensko.digital/img/clenstvo/manifest-og.png'
  erb :membership
end

get '/clenovia' do
  @page.title = 'Členovia'
  erb :members
end

get '/' do
  erb :index
end

get '/co-robime' do
  erb :index
end

get '/projekty' do
  @page.title = 'Projekty'
  erb :'projects/index'
end

get '/projekty/red-flags' do
  @page.title = 'Red Flags'
  erb :'projects/red_flags'
end

get '/projekty/lepsi-egovernment' do
  @page.title = 'Lepšie služby e-Governmentu'
  erb :'projects/better_egovernment'
end

get '/projekty/ekosystem' do
  @page.title = 'Ekosystém'
  erb :'projects/ekosystem'
end

get '/o-nas/?' do
  @page.title = 'O nás'
  erb :about
end

get '/vyrocne-spravy/?' do
  @page.title = 'Výročné správy'
  erb :annual_reports
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

get '/ochrana-osobnych-udajov' do
  @page.title = 'Informácie o spracúvaní osobných údajov'
  erb :privacy_policy
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

get '/dve_percenta_info/?' do
  @page.title = '2% z dane – informácie'
  erb :two_percent_info
end

get '/dve_percenta/?' do
  @page.title = '2% z dane'
  @page.og.title = '2% pre lepší e-Government'
  @page.og.description = 'Už viac ako 2 roky bojujeme aj za Vás. Ak sa Vám páči čo robíme, prosíme o Vašu podporu.'
  @page.og.image = 'https://slovensko.digital/img/two_percent/2percent_header_meta.png'
  erb :two_percent_landing
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

get '/zapoj-sa' do
  @page.title = 'Zapoj sa'
  #TODO OG
  @activities = YAML.load_file('data/participation_activities.yml').map{ |v| OpenStruct.new(v) }.first(3)
  erb :'participation/index'
end

get '/zapoj-sa/aktivity' do
  @page.title = 'Zoznam aktivít'
  #TODO OG
  @activities = YAML.load_file('data/participation_activities.yml').map{ |v| OpenStruct.new(v) }
  erb :'participation/activities'
end

not_found do
  erb :'404'
end

get '/oz/novinky/?' do
  redirect to('/aktuality')
end
