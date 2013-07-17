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
end
