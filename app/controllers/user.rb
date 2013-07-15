MyAnimeListApiRefactor::App.controllers :user do

  get :profile, map: '/user/:username/profile' do
    profile_page = HTTParty.get("http://myanimelist.net/profile/#{params[:username]}")
    profile = ProfileScraper.scrape(profile_page.body)

    if profile.nil?
      status 404
      body "User #{params[:username]} could not be found"
    else
      profile.to_json
    end
  end

  get :animelist, map: '/user/:username/animelist' do
  end

  get :mangalist, map: '/user/:username/mangalist' do
  end

  get :history, map: '/user/:username/history(/:type)' do
    url = "http://myanimelist.net/history/#{params[:username]}"
    type = params[:type]
    unless type.nil? then url << "/#{type.to_s}" end

    history_page = HTTParty.get(url)
    history = UserHistoryScraper.scrape(history_page.body)

    if history.nil?
      status 404
      body "User #{params[:username]} could not be found"
    else
      history.to_json
    end
  end
end
