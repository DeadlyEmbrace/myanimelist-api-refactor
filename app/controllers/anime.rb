MyAnimeListApiRefactor::App.controllers :anime do

  get :show, 'anime/:id' do
    anime_page = MALRequester.get "http://myanimelist.net/anime/#{params[:id]}"
    anime = AnimeScraper.scrape(anime_page.body)

    if anime.nil?
      status 404
      body "Anime with id #{params[:id]} could not be found"
    else
      anime.to_json
    end
  end

  get :search, with: :query do
    search_page = MALRequester.get "http://myanimelist.net/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=#{CGI.escape(params[:query])}"

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
