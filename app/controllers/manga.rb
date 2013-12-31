MyAnimeListApiRefactor::App.controllers :manga do
  get :index, with: :id do
    manga_page = mal_requester.manga(params[:id])
    manga = MangaScraper.scrape(manga_page.body)

    if manga.nil?
      handle_404 "Manga with id #{params[:id]} could not be found"
    else
      manga.to_json
    end
  end

  get :search, with: :query do
    search_page = mal_requester.manga_search(query: params[:query], page: params[:page])

    # If the search page only has one result, MyAnimeList redirects to the
    # anime details page of that results.
    if search_page.request.redirect
      search_results = [MangaScraper.scrape(search_page.body)]
    else
      search_results = MangaSearchScraper.scrape(search_page.body)
    end

    search_results.to_json
  end
end
