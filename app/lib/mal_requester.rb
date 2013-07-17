class MALRequester
  include HTTParty

  base_uri 'myanimelist.net'
  headers 'User-Agent' => 'MyAnimeList Unofficial API (http://mal-api.com/)'
end