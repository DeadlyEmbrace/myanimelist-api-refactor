class MALRequester
  include HTTParty

  base_uri 'myanimelist.net'
  headers 'User-Agent' => ENV['API_KEY']
end