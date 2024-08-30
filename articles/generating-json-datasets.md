# Generating Football JSON Datasets


Let's update and (re)generate
the [/football.json datasets](https://github.com/openfootball/football.json) 
that offer 
free open public domain football data in the JSON (JavaScript Object Notation) 
data interchange format
that you can use as (static) web services with no API key or signup required ;-), for example.
Football leagues include:

- English Premier League
- Deutsche Bundesliga
- Spanish Primera División ("La Liga")
- Italian Serie A
- and more


## Step 1 - Let's read in the sources in football.txt into an SQL database

Let's start with the English Premier League.
Get a copy of the [/england datasets](https://github.com/openfootball/england). 
Use git clone or download and
unpack the zip archive.

Let's start from scratch / zero and let's build a single-file SQLite database
(e.g. `./england.db`):


``` ruby
require 'sportdb/readers'


SportDb.connect( adapter:  'sqlite3',
                 database: './england.db' )
SportDb.create_all       ## build database schema (tables, indexes, etc.)
```

Next let's read in the sources into the SQL database:

``` ruby
## assumes football.db datasets for England in local ./england directory
SportDb.read( './england' )
```

And now onto...


## Step 2 - Let's generate the JSON datasets using the SQL database

Let's code a `gen_json` helper where you pass in the 
league code (e.g. `eng.1` for the English Premier League)
and the output root directory where the new datasets get filed in 
new subdirectories season by season (e.g. `/2018-19`, `/2019-20`, etc.) 

``` ruby
def gen_json( league_key, out_root: )

  league = SportDb::Model::League.find_by!( key: league_key )

  league.events.each do |event|
     puts "=== event: #{event.name} ==="
     puts "  teams.count: #{event.teams.count}"
     puts "  rounds.count: #{event.rounds.count}"
     puts "  matches.count: #{event.matches.count}"

     ## build path e.g.
     ##  2019-20/eng.1.clubs.json

     league_basename = event.league.key   ## e.g. eng.1
     season_basename = event.season.name.sub('/', '-')  ## e.g. change 2019/20 to 2019-20

     out_dir   = "#{out_root}/#{season_basename}"
     ## make sure folders exist
     FileUtils.mkdir_p( out_dir ) unless Dir.exists?( out_dir )

     File.open( "#{out_dir}/#{league_basename}.clubs.json", 'w:utf-8' ) do |f|
       f.write JSON.pretty_generate( build_clubs( event ) )
     end

     File.open( "#{out_dir}/#{league_basename}.json", 'w:utf-8' ) do |f|
       f.write JSON.pretty_generate( build_matches( event ) )
     end
  end
end
```

and lets add the "secret sauce", that is, the `build_clubs` and `build_matches`
helpers that do the heavy-lifting data conversion to JSON:

``` ruby
def build_clubs( event )
  clubs = []
  event.teams.each do |team|
    clubs << { key:  team.key,
               name: team.name,
               code: team.code }
  end

  data = {
   name:  event.name,
   clubs: clubs
  }

  data
end

def build_matches( event )
  rounds = []
  event.rounds.each do |round|
    matches = []
    round.matches.each do |match|
      matches << { date: match.date.strftime( '%Y-%m-%d'),
                   team1: {
                     key:  match.team1.key,
                     name: match.team1.name,
                     code: match.team1.code
                   },
                   team2: {
                     key:  match.team2.key,
                     name: match.team2.name,
                     code: match.team2.code
                   },
                   score1: match.score1,
                   score2: match.score2 }
    end

    rounds << { name:    round.name,
                matches: matches }
  end

  data = {
    name:   event.name,
    rounds: rounds
  }

  data
end
```

And let's start generating...

``` ruby
gen_json( 'eng.1', out_root: './' )
```

resulting in:

```
/2019-20
   eng.1.json
   eng.1.clubs.json
/2018-19
   eng.1.json
   eng.1.clubs.json
# ...
```

and if you open up `2019-20/eng.1.json` it reads:

``` json
{
  "name": "Premier League 2019/20",
  "rounds": [
    {
      "name": "Matchday 1",
      "matches": [
        {
          "date": "2019-08-09",
          "team1": {
            "key": "liverpool",
            "name": "Liverpool FC",
            "code": "LIV"
          },
          "team2": {
            "key": "norwich",
            "name": "Norwich City FC",
            "code": "NOR"
          },
          "score1": 4,
          "score2": 1
        },
        {
          "date": "2019-08-10",
          "team1": {
            "key": "westham",
            "name": "West Ham United FC",
            "code": "WHU"
          },
          "team2": {
            "key": "mancity",
            "name": "Manchester City FC",
            "code": "MCI"
          },
          "score1": 0,
          "score2": 5
        },
        # ...
      ]
    }
  ]
}  
```

That's it.
Bonus: Why not generate football.json datasets for the Bundesliga, La Liga, Ligue 1, 
Seria A, or your very own league? Yes, you can.

Enjoy data wrangling and the beautiful game with ruby.
