MyAnimeListApiRefactor::App.controllers :user do
  before :animelist_add do
    authenticate unless authenticated?
  end


  get :index, with: :username do
    profile_page = mal_requester.user_profile(params[:username])
    profile = ProfileScraper.scrape(profile_page.body)

    if profile.nil?
      handle_404 "User #{params[:username]} could not be found"
    else
      profile.to_json
    end
  end

  get :animelist, map: '/user/:username/animelist' do
    anime_list_page = mal_requester.user_animelist(params[:username])
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
    manga_list_page = mal_requester.user_mangalist(params[:username])
    manga_list = MangaListScraper.scrape(manga_list_page.body)

    if manga_list.nil?
      handle_404 "User #{params[:username]} could not be found"
    else
      manga_list.to_json
    end
  end

  get :history, map: '/user/:username/history(/:type)' do
    params[:type] = params[:type].to_sym unless params[:type].nil?
    history_page = mal_requester.user_history(username: params[:username], type: params[:type])
    history = UserHistoryScraper.scrape(history_page.body)

    if history.nil?
      handle_404 "User #{params[:username]} could not be found"
    else
      history.to_json
    end
  end
end