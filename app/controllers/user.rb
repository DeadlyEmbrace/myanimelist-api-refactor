MyAnimeListApiRefactor::App.controllers :user do

  get :profile, map: '/user/:username/profile' do
    profile_page = MALRequester.get("http://myanimelist.net/profile/#{params[:username]}")
    profile = ProfileScraper.scrape(profile_page.body)

    if profile.nil?
      status 404
      body "User #{params[:username]} could not be found"
    else
      profile.to_json
    end
  end

  get :animelist, map: '/user/:username/animelist' do
    anime_list_page = MALRequester.get("http://myanimelist.net/malappinfo.php?u=#{params[:username]}&status=all&type=anime")
    anime_list = AnimeListScraper.scrape(anime_list_page.body)

    if anime_list.nil?
      status 404
      body "User #{params[:username]} could not be found"
    else
      anime_list.to_json
    end
  end

  get :mangalist, map: '/user/:username/mangalist' do
    manga_list_page = MALRequester.get("http://myanimelist.net/malappinfo.php?u=#{params[:username]}&status=all&type=manga")
    manga_list = MangaListScraper.scrape(manga_list_page.body)

    if manga_list.nil?
      status 404
      body "User #{params[:username]} could not be found"
    else
      manga_list.to_json
    end
  end

  get :history, map: '/user/:username/history(/:type)' do
    url = "http://myanimelist.net/history/#{params[:username]}"
    type = params[:type]
    unless type.nil? then url << "/#{type.to_s}" end

    history_page = MALRequester.get(url)
    history = UserHistoryScraper.scrape(history_page.body)

    if history.nil?
      status 404
      body "User #{params[:username]} could not be found"
    else
      history.to_json
    end
  end
end