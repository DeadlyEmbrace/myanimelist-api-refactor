MyAnimeListApiRefactor::App.controllers :anime do
  get :upcoming do
    date = if params[:start_date].nil? then nil else Chronic.parse(params[:start_date]).to_date end
    search_page = mal_requester.upcoming_anime(page: params[:page], since: date)

    # If the search page only has one result, MyAnimeList redirects to the
    # anime details page of that results.
    if search_page.request.redirect
      search_results = [AnimeScraper.scrape(search_page.body)]
    else
      search_results = AnimeSearchScraper.scrape(search_page.body)
    end

    search_results.to_json
  end

  get :just_added do
    search_page = mal_requester.just_added_anime(page: params[:page])

    # If the search page only has one result, MyAnimeList redirects to the
    # anime details page of that results.
    if search_page.request.redirect
      search_results = [AnimeScraper.scrape(search_page.body)]
    else
      search_results = AnimeSearchScraper.scrape search_page.body
    end
    search_results.to_json
  end

  get :top, '/anime/top(/:type)' do
    params[:type] = params[:type].to_sym unless params[:type].nil?
    top_anime_page = mal_requester.top_anime(page: params[:page], type: params[:type])
    top_anime = TopAnimeScraper.scrape top_anime_page.body
    top_anime.to_json
  end

  get :popular do
    top_anime_page = mal_requester.top_anime(page: params[:page], type: :bypopularity)
    top_anime = TopAnimeScraper.scrape top_anime_page.body
    top_anime.to_json
  end

  get :index, with: :id do
    anime_page = mal_requester.anime(params[:id])
    anime = AnimeScraper.scrape(anime_page.body)

    if anime.nil?
      handle_404 "Anime with id #{params[:id]} could not be found"
    else
      anime.to_json
    end
  end

  get :search, with: :query do
    search_page = mal_requester.search_anime(query: params[:query], page: params[:page])

    # If the search page only has one result, MyAnimeList redirects to the
    # anime details page of that results.
    if search_page.request.redirect
      search_results = [AnimeScraper.scrape(search_page.body)]
    else
      search_results = AnimeSearchScraper.scrape(search_page.body)
    end

    search_results.to_json
  end
end