# sport.db.starter - Build Your Own HTTP JSON API (Ruby Edition)

The sportdb web service starter sample lets you build your own HTTP JSON API
using the
[`football.db`](https://github.com/openfootball),
[`worldcup.db`](https://github.com/openfootball/world-cup),
[`ski.db`](https://github.com/opensport/ski.db),
[`formulal1.db`](https://github.com/opensport/formula1.db), etc.  Example:

```ruby
class StarterApp < Sinatra::Base

  ##########
  # Models

  include SportDb::Models    # e.g. Event, Team, Round, League, Season, etc.

  ############################################
  # Controllers / Routing / Request Handlers

  get '/events' do
    events = []
    Event.order(:id).each do |ev|
      events << { key: ev.key, title: ev.title }
    end

    json_or_jsonp( events )
  end

  get '/event/:key/teams' do |key|
    # note: change en.2014_15 or en.2014-15 to en.2014/15
    event = Event.find_by_key!( key.tr('_', '/').tr('-', '/') )

    teams = []
    event.teams.each do |t|
      teams << { key: t.key, title: t.title, code: t.code }
    end

    data = { event: { key: event.key, title: event.title }, teams: teams }

    json_or_jsonp( data )
  end

  ...
end # class StarterApp
```

(Source: [`app.rb`](app.rb))



## Getting Started

Step 1: Install all libraries (Ruby gems) using bundler. Type:

    $ bundle install

Step 2: Copy an SQLite database e.g. `football.db` into your folder.

Step 3: Startup the web service (HTTP JSON API). Type:

    $ ruby server.rb

That's it. Open your web browser and try some services
running on your machine on port 9292 (e.g. `localhost:9292`). Example:


List all services (endpoints):

- `http://localhost:9292`

Results in:

```json
{
  "endpoints": {
    "list_events": {
      "doc": "list all events",
      "url": "/events"
    },
    "list_event_teams": {
      "doc": "list teams for an event",
      "url": "/event/:key/teams"
    },
    "list_event_rounds": {
      "doc": "list rounds for an event",
      "url": "/event/:key/rounds"
    },
    "list_event_games_for_round": {
      "doc": "list games for an event round",
      "url": "/event/:key/round/:pos"
    }
  }
}
```

List all events:

- `http://localhost:9292/events`

List all English Premier League 2014/15 teams:

- `http://localhost:9292/event/en.2014_15/teams`

List all English Premier League 2014/15 rounds:

- `http://localhost:9292/event/en.2014_15/rounds`

List English Premier League 2014/15 round 1:

- `http://localhost:9292/event/en.2014_15/round/1`



And so on. Now change the [`app.rb`](app.rb) script to fit your needs. Be bold. Enjoy.


## License

The `sportdb.db.starter` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)

