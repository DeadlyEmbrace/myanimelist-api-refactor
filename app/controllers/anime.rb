MyAnimeListApiRefactor::App.controllers :anime do
  get :upcoming do
    page = (params[:page].to_i - 1) * 20 unless params[:page].nil?
    date = Chronic.parse('today')
    date = Chronic.parse params[:start_date] unless params[:start_date].nil?
    url = "/anime.php?o=2&w=&c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&cv=1&em=0&ed=0&ey=0&sm=#{date.month}&sd=#{date.day}&sy=#{date.year}"
    url << "&show=#{page}" unless page.nil?
    search_page = MALRequester.get url

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
    page = (params[:page].to_i - 1) * 20 unless params[:page].nil?
    url = '/anime.php?o=9&w=1&c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&cv=2'
    url << "&show=#{page}" unless page.nil?
    search_page = MALRequester.get url

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
    options = {}
    options[:limit] = (params[:page].to_i - 1) * 20 unless params[:page].nil?
    options[:type] = params[:type].to_s.downcase unless params[:type].nil?
    options = nil if options.empty?
    top_anime_page = MALRequester.get '/topanime.php', query: options
    top_anime = TopAnimeScraper.scrape top_anime_page.body
    top_anime.to_json
  end

  get :popular do
    options = { type: 'bypopularity' }
    options[:limit] = (params[:page].to_i - 1) * 20 unless params[:page].nil?
    top_anime_page = MALRequester.get '/topanime.php', query: options
    top_anime = TopAnimeScraper.scrape top_anime_page.body
    top_anime.to_json
  end

  get :index, with: :id do
    anime_page = MALRequester.get "/anime/#{params[:id]}"
    anime = AnimeScraper.scrape(anime_page.body)

    if anime.nil?
      status 404
      body "Anime with id #{params[:id]} could not be found"
    else
      anime.to_json
    end
  end

  get :search, with: :query do
    page = (params[:page].to_i - 1) * 20 unless params[:page].nil?
    url = "/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=#{CGI.escape(params[:query])}"
    url << "&show=#{page}" unless page.nil?
    search_page = MALRequester.get url

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