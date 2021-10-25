require 'sinatra'
require 'sinatra/multi_route'
require 'sinatra/reloader' if development?
require 'newrelic_rpm'
require_relative 'data/participation_activity'

before do
  # TODO sane defaults
  @page = OpenStruct.new(
    url: request.url.split('?').first,
    og: OpenStruct.new(
      image: 'http://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/2X/8/81f213b2919f9e7d944d5d00c0150b8406503988.png',
      secure_url: 'https://platforma-slovensko-digital-files.s3-eu-central-1.amazonaws.com/original/2X/8/81f213b2919f9e7d944d5d00c0150b8406503988.png',
      description: 'Chceme, aby boli digitálne služby štátu jednoduché a dávali zmysel.'
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

get '/projekty/red-flags-5-0-sd-za' do
  @page.title = 'Red Flags 5.0: SD ZA'
  erb :'projects/red_flags_5_0_sd_za'
end

get '/projekty/ekosystem' do
  @page.title = 'Ekosystém'
  erb :'projects/ekosystem'
end

get '/projekty/lepsie-sluzby' do
  @page.title = 'LepšieSlužby.sk'
  erb :'projects/lepsie_sluzby'
end

get '/projekty/lepsi-egovernment' do
  @page.title = 'Lepšie služby e-Governmentu'
  erb :'projects/better_egovernment'
end

get '/projekty/aj-ty-si-slovensko-digital' do
  @page.title = 'Aj Ty si Slovensko.Digital'
  erb :'projects/aj_ty_si_slovensko'
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

get '/zverejnene-vyzvy' do
  @page.title = 'Zverejnené výzvy'
  erb :appeals
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

get '/dodrziavanie-etickeho-kodexu/?' do
  @page.title = 'Dodržiavanie Etického kódexu'
  erb :adhering_to_codex
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
  redirect to('/dve-percenta#ako-poukazat')
end

get '/dve_percenta/?' do
  redirect to('/dve-percenta')
end

get '/dve-percenta' do
  @page.title = '2% z dane'
  @page.og.title = '2% pre lepší e-Government'
  @page.og.description = 'Aj Vaše 2% nám pomôžu bojovať za lepší e-Government'
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

get '/benefit-plus/?' do
  @page.title = 'Benefit Plus'
  erb :benefit_plus
end

get '/kontakt/?' do
  @body_class = 'main'
  @page.title = 'Kontakt'
  erb :contact
end

get '/narodeniny/?' do
  @page.title = 'Narodeniny'
  @page.og.title = 'Slovensko.Digital oslavuje tretie narodeniny!'
  @page.og.image = 'http://slovensko.digital/img/birthday/og.jpg'
  @page.og.secure_url = 'https://slovensko.digital/img/birthday/og.jpg'
  @page.og.description = 'Už tretí rok sa snažíme o to, aby štátne IT bolo lepšie. Veľa sa nám podarilo a veľa nás ešte čaká. Potrebujeme tvoju pomoc.'
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

get '/vyzva/?' do
  redirect 'http://vyzva.slovensko.digital/'
end

get '/zapoj-sa' do
  @page.title = 'Zapoj sa'
  @page.og.title = 'Zapoj sa'
  @page.og.description = 'V Slovensko.Digital veríme, že spolu s komunitou vieme dosiahnuť oveľa viac. Nezáleží na tom, či si úradník, programátor, laik či politik. Ak nám chceš pomôcť v našej snahe o lepšie IT, pozri si aktivity do ktorých sa vieš zapojiť už teraz.'
  @page.og.image = 'https://slovensko.digital/img/participacia-og.png'

  @activities = [
    ParticipationActivity.find_by_id('zacni_programovat'),
    ParticipationActivity.find_by_id('uzivatelske_prirucky'),
    ParticipationActivity.find_by_id('rozbehni_spolupracu_s_it_komunitou')
  ]
  erb :'participation/index'
end

get '/zapoj-sa/aktivity' do
  @page.title = 'Zoznam aktivít'
  @page.og.title = 'Zapoj sa: Zoznam aktivít'
  @page.og.description = 'V Slovensko.Digital veríme, že spolu s komunitou vieme dosiahnuť oveľa viac. Nezáleží na tom, či si úradník, programátor, laik či politik. Ak nám chceš pomôcť v našej snahe o lepšie IT, pozri si aktivity do ktorých sa vieš zapojiť už teraz.'
  @page.og.image = 'https://slovensko.digital/img/participacia-og.png'

  @activities = ParticipationActivity.all
  erb :'participation/activities'
end

ParticipationActivity.all.each do |activity|
  get "/zapoj-sa/#{activity.url}" do
    @page.title = activity.title
    @activity = activity

    @page.og.title = activity.title
    @page.og.description = activity.perex
    @page.og.image = 'https://slovensko.digital/img/participacia-og.png'

    erb :"participation/activity_layout" do
      erb :"participation/_#{activity.partial}"
    end
  end
end

not_found do
  erb :'404'
end

get '/oz/novinky/?' do
  redirect to('/aktuality')
end
