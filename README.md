myanimelist-api-refactor
========================

[![Build Status](https://secure.travis-ci.org/astraldragon/myanimelist-api-refactor.png)](https://travis-ci.org/astraldragon/myanimelist-api-refactor)
[![Code Climate](https://codeclimate.com/github/astraldragon/myanimelist-api-refactor.png)](https://codeclimate.com/github/astraldragon/myanimelist-api-refactor)
[![Dependency Status](https://gemnasium.com/astraldragon/myanimelist-api-refactor.png)](https://gemnasium.com/astraldragon/myanimelist-api-refactor)

Refactor of the Unofficial MyAnimeList API

Goals of this project include

- Maybe deploy to Heroku
- Better organization of routes
- Seperation of models, scraping code, and web request code
- Reduce duplication
- Add unit testing
- An alternative for documentation (perhaps Apiary)

Current Changes
===============

User Endpoint
-------------

Updated URLs

- /profile/astraldragon88 to /user/astraldragon88/profile
- /animelist/astraldragon88 to /user/astraldragon88/animelist
- /mangalist/astraldragon88 to /user/astraldragon88/mangalist
- /animelist/astraldragon88 to /user/astraldragon88/animelist
- /history/astraldragon88 to /user/astraldragon88/history
- /history/astraldragon88/anime to /user/astraldragon88/history/anime
- /history/astraldragon88/manga to /user/astraldragon88/history/manga

Other changes

- Made responses more consistent (all responses return 404 when user does not exist)