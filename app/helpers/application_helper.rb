MyAnimeListApiRefactor::App.helpers do
  include MyAnimeListApiRefactor::Authorization

  def mal_requester
    @mal_requester ||= MALRequester.new(ENV['API_KEY'])
  end
end