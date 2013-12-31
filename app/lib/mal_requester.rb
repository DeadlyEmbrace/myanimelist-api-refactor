class MALRequester
  include HTTParty

  base_uri 'myanimelist.net'

  def initialize(api_key)
    self.class.headers 'User-Agent' => api_key
  end

  def anime(id)
    raise ArgumentError if id.nil?
    self.class.get "/anime/#{id}"
  end

  def just_added_anime(opts)
    page = if opts[:page].nil? then nil else calculate_pagination opts[:page] end
    url = '/anime.php?o=9&w=1&c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&cv=2'
    url << "&show=#{page}" unless page.nil?
    self.class.get url
  end

  def upcoming_anime(opts)
    page = if opts[:page].nil? then nil else calculate_pagination opts[:page] end
    date = opts[:since] || Date.today
    url = "/anime.php?o=2&w=&c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&cv=1&em=0&ed=0&ey=0&sm=#{date.month}&sd=#{date.day}&sy=#{date.year}"
    url << "&show=#{page}" unless page.nil?
    self.class.get url
  end

  def search_anime(opts)
    raise ArgumentError if opts[:query].nil?
    page = if opts[:page].nil? then nil else calculate_pagination opts[:page] end
    url = "/anime.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=#{CGI.escape(opts[:query])}"
    url << "&show=#{page}" unless page.nil?
    self.class.get url
  end

  def top_anime(opts)
    accepted_types = [:tv, :movie, :ova, :special, :bypopularity]
    raise ArgumentError if opts[:type] && !accepted_types.include?(opts[:type])
    options = {}
    options[:type] = opts[:type].to_s unless opts[:type].nil?
    options[:limit] = calculate_pagination(opts[:page]) unless opts[:page].nil?
    options = nil if options.empty?
    self.class.get '/topanime.php', query: options
  end

  def manga(id)
    raise ArgumentError if id.nil?
    self.class.get "/manga/#{id}"
  end

  def manga_search(opts)
    raise ArgumentError if opts[:query].nil?
    page = if opts[:page].nil? then nil else calculate_pagination opts[:page] end
    url = "/manga.php?c[]=a&c[]=b&c[]=c&c[]=d&c[]=e&c[]=f&c[]=g&q=#{CGI.escape(opts[:query])}"
    url << "&show=#{page}" unless page.nil?
    self.class.get url
  end

  def user_profile(username)
    raise ArgumentError if username.nil?
    self.class.get "/profile/#{username}"
  end

  def user_animelist(username)
    raise ArgumentError if username.nil?
    options = { u: username, status: 'all', type: 'anime' }
    self.class.get '/malappinfo.php', query: options
  end

  def user_mangalist(username)
    raise ArgumentError if username.nil?
    options = { u: username, status: 'all', type: 'manga' }
    self.class.get '/malappinfo.php', query: options
  end

  def user_history(opts)
    accepted_types = [:anime, :manga]
    raise ArgumentError if opts[:username].nil?
    raise ArgumentError if opts[:type] && !accepted_types.include?(opts[:type])
    opts[:type] = opts[:type].to_s unless opts[:type].nil?
    url = "/history/#{opts[:username]}"
    url << "/#{opts[:type]}" unless opts[:type].nil?
    self.class.get url
  end

  private
    def calculate_pagination(page, size = 20)
      (page.to_i - 1) * size
    end
end