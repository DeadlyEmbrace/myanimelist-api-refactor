MyAnimeListApiRefactor::App.controllers :manga do
  get :index, with: :id do
    manga_page = MALRequester.get "/manga/#{params[:id]}"
    manga = MangaScraper.scrape(manga_page.body)

    if manga.nil?
      handle_404 "Manga with id #{params[:id]} could not be found"
    else
      manga.to_json
    end
  end

  get :search, with: :query do
    page = (params[:page].to_i - 1) * 20 unless params[:page].nil?
    url = "/manga.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=#{CGI.escape(params[:query])}"
    url << "&show=#{page}" unless page.nil?
    search_page = MALRequester.get url

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
