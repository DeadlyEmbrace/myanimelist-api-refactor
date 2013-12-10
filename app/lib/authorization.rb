module MyAnimeListApiRefactor
  module Authorization
    def auth
      @auth ||= ::Rack::Auth::Basic::Request.new(request.env)
    end

    def unauthenticated!(realm = 'myanimelist.net')
      headers['WWW-Authenticate'] = %(Basic realm="#{realm}")
      throw :halt, [ 401, 'Authorization Required' ]
    end

    def bad_request!
      throw :halt, [ 400, 'Bad Request' ]
    end

    def authenticated?
      request.env['REMOTE_USER']
    end

    def authenticate_with_mal(username, password)
      options = { username: username, password: password, cookies: 1 }
      response = MALRequester.post '/login.php', { follow_redirects: false, body: options }
      authenticated = response.headers['location'] == 'http://myanimelist.net/panel.php'
      session['cookie_string'] = generate_session(response) if authenticated
      authenticated
    end

    def generate_session(response)
      matches = response.headers['set-cookie'].scan(/(?<key>(A|B)=[^\;]+\;)/)
      matches.join(' ')
    end

    def authenticate
      return if authenticated?
      unauthenticated! unless auth.provided?
      bad_request! unless auth.basic?
      unauthenticated! unless authenticate_with_mal(*auth.credentials)
      request.env['REMOTE_USER'] = auth.username
    end
  end
end