MyAnimeListApiRefactor::App.controllers :user do
  before :animelist_add do
    authenticate unless authenticated?
  end


  get :index, with: :username do
    profile_page = MALRequester.get("/profile/#{params[:username]}")
    profile = ProfileScraper.scrape(profile_page.body)

    if profile.nil?
      handle_404 "User #{params[:username]} could not be found"
    else
      profile.to_json
    end
  end

  get :animelist, map: '/user/:username/animelist' do
    options = { u: params[:username], status: 'all', type: 'anime' }
    anime_list_page = MALRequester.get '/malappinfo.php', query: options
    anime_list = AnimeListScraper.scrape(anime_list_page.body)

    if anime_list.nil?
      handle_404 "User #{params[:username]} could not be found"
    else
      anime_list.to_json
    end
  end

  post :animelist_add, map: '/user/:username/animelist/:anime_id' do
    handle_400 'Please supply a valid anime id' unless params[:anime_id] =~ /\d+/
  end

  get :mangalist, map: '/user/:username/mangalist' do
    options = { u: params[:username], status: 'all', type: 'manga' }
    manga_list_page = MALRequester.get '/malappinfo.php', query: options
    manga_list = MangaListScraper.scrape(manga_list_page.body)

    if manga_list.nil?
      handle_404 "User #{params[:username]} could not be found"
    else
      manga_list.to_json
    end
  end

  get :history, map: '/user/:username/history(/:type)' do
    url = "/history/#{params[:username]}"
    type = params[:type]
    unless type.nil? then url << "/#{type.to_s}" end

    history_page = MALRequester.get(url)
    history = UserHistoryScraper.scrape(history_page.body)

    if history.nil?
      handle_404 "User #{params[:username]} could not be found"
    else
      history.to_json
    end
  end
end