# sport.db (incl. football.db) Scripts & Tools Docs



The sport.db. build blocks (gem family):

## sportdb/structs  - Core Data Structures

``` ruby
require 'sportdb/structs'

rapid   = Club.new( name: 'Rapid Wien' )
austria = Club.new( name: 'Austria Wien' )

england  = NationalTeam.new( name: 'England', code: 'ENG' )
spain    = NationalTeam.new( name: 'France',  code: 'FRA' )

# ...
```


## sportdb/parser   -  Low-Level Football.TXT Tokenizer & Parser


``` ruby
require 'sportdb/parser

txt =<<TXT
Semi-finals
Tue Jul/9
(49)  21:00    Spain  2-1 (2-1)  France           @ München
                  Yamal 21' Olmo 25'; Kolo Muani 8'
Wed Jul/10
(50)  21:00    Netherlands  1-2 (1-1)   England    @ Dortmund
                  Simons 7'; Kane 18' (pen.) Watkins 90+1'

Final
Sun Jul/14
(51)   21:00   Spain  -  England         @ Berlin
TXT

parser = SportDb::Parser.new

tokens = []
txt.each_line do |line,i|
  ## skip blank or comment lines
  next if line.strip.empty? || line.strip.start_with?( '#' )
  t = parser.tokenize( line )
  tokens << t
end
pp tokens
```

resulting in:
``` ruby
 [[[:text, "Semi-finals"]],
  [[:date, "Tue Jul/9"]],
  [[:num, "(49)"],
   [:time, "21:00"],
   [:text, "Spain"],
   [:score, "2-1 (2-1)"],
   [:text, "France"],
   [:"@"],
   [:text, "München"]],
  [[:text, "Yamal"],
   [:minute, "21'"],
   [:text, "Olmo"],
   [:minute, "25'"],
   [:";"],
   [:text, "Kolo Muani"],
   [:minute, "8'"]],
  [[:date, "Wed Jul/10"]],
  [[:num, "(50)"],
   [:time, "21:00"],
   [:text, "Netherlands"],
   [:score, "1-2 (1-1)"],
   [:text, "England"],
   [:"@"],
   [:text, "Dortmund"]],
  [[:text, "Simons"],[:minute, "7'"],
   [:";"],
   [:text, "Kane"],[:minute, "18'"],[:pen, "(pen.)"],
   [:text, "Watkins"],[:minute, "90+1'"]],
  [[:text, "Final"]],
  [[:date, "Sun Jul/14"]],
  [[:num, "(51)"], [:time, "21:00"],
    [:text, "Spain"], [:vs, "-"], [:text, "England"],
    [:"@"], [:text, "Berlin"]]
]
```


## sportdb/text    -  Read Football.TXT Into Structs or Read CSV

depends on sportdb/structs & sportdb/parser


``` ruby
require 'sportdb/text'

txt =<<TXT
= Euro 2024

# ...

Semi-finals
Tue Jul/9
(49)  21:00    Spain  2-1 (2-1)  France           @ München
                  Yamal 21' Olmo 25'; Kolo Muani 8'
Wed Jul/10
(50)  21:00    Netherlands  1-2 (1-1)   England    @ Dortmund
                  Simons 7'; Kane 18' (pen.) Watkins 90+1'

Final
Sun Jul/14
(51)   21:00   Spain  -  England         @ Berlin
TXT


matches = QuickMatcherReader.parse( txt )
data = matches.map {|match| match.as_json }   ## convert (match) structs to json
pp data
```

resulting in

``` json
[
        {
          "num": 49,
          "date": "2024-07-09",
          "time": "21:00",
          "team1": { "name": "Spain",  "code": "ESP" },
          "team2": { "name": "France", "code": "FRA" },
          "score": { "ft": [2,1],
                     "ht": [2,1] },
          "goals1": [{"name": "Yamal",      "minute": 21},
                     {"name": "Olmo",       "minute": 25}],
          "goals2": [{"name": "Kolo Muani", "minute": 8 }],
          "round": "Semi-finals"
        },
        {
          "num": 50,
          "date": "2024-07-10",
          "time": "21:00",
          "team1": { "name": "Netherlands", "code": "NED" },
          "team2": { "name": "England",     "code": "ENG" },
          "score": { "ft": [1,2],
                     "ht": [1,1] },
          "goals1": [{"name": "Simons",  "minute": 7 }],
          "goals2": [{"name": "Kane",    "minute": 18, "penalty": true },
                     {"name": "Watkins", "minute": 90, "offset": 1 }],
          "round": "Semi-finals"
        },
        {
          "num": 51,
          "date": "2024-07-14",
          "time": "21:00",
          "team1": { "name": "Spain",   "code": "ESP" },
          "team2": { "name": "England", "code": "ENG" },
          "score": { "ft": [2,1],
                     "ht": [0,0] },
          "goals1": [{"name": "Williams",  "minute": 47},
                     {"name": "Oyarzabal", "minute": 86}],
          "goals2": [{"name": "Palmer",    "minute": 73}],
          "round": "Final"
      }
]
```




## sportdb/search   -  Search for Clubs & National Teams, Leagues & Cups, Countries & Cities, and More

depends on sportdb/structs & sportdb/catalogs (built-in default sqlite dbs for search)


```ruby
require 'sportdb/search'

Club.match_by( name: 'arsenal' )
Club.match_by( name: 'liverpool' )

Club.match_by( name: 'az' )
Club.match_by( name: 'bayern' )

Club.match_by( name: 'Arsenal', country: 'eng' )
Club.match_by( name: 'Arsenal', country: 'Argentina' )


League.match_by( name: 'English Premier League' )
League.match_by( name: 'Euro' )
League.match_by( name: 'Premier League',
                           country: 'eng' )
League.match_by( name: 'Premier League',
                           country: 'England' )


Ground.match_by( name: 'Waldstadion' )
Ground.match_by( name: 'Waldstadion', country: 'de' )
Ground.match_by( name: 'Waldstadion', city: 'Frankfurt' )

Ground.match_by( name: 'Stade de France' )
Ground.match_by( name: 'Stade de France', city: 'Paris' )
Ground.match_by( name: 'Stade de France', city: 'Saint-Denis' )

# ...
```



## sportdb/models   - SQL DB Schema (Tables, Indexes, etc) & Models




## sportdb/readers  -  Read Football.TXT Into SQL DBs

depends on sportdb/models (for db machinery)
and sportdb/text & search.


**Step 1**

Setup the (SQL) database. Let's use and build a single-file SQLite database (from scratch),
as an example:

``` ruby
require 'sportdb/readers'

SportDb.open( './england.db' )
```

**Step 2**

Let's read in some leagues, seasons, clubs, and match schedules and results.
Let's use the public domain football.db datasets for England (see [`openfootball/england`](https://github.com/openfootball/england)), as an example:


```
= English Premier League 2015/16

Matchday 1

[Sat Aug 8]
  Manchester United      1-0  Tottenham Hotspur
  AFC Bournemouth        0-1  Aston Villa
  Everton FC             2-2  Watford FC
  Leicester City         4-2  Sunderland AFC
  Norwich City           1-3  Crystal Palace
  Chelsea FC             2-2  Swansea City
[Sun Aug 9]
  Arsenal FC             0-2  West Ham United
  Newcastle United       2-2  Southampton FC
  Stoke City             0-1  Liverpool FC
[Mon Aug 10]
  West Bromwich Albion   0-3  Manchester City

...
```

(Source: [england/2015-16/1-premierleague.txt](https://github.com/openfootball/england/blob/master/2015-16/1-premierleague.txt))

and let's try:

``` ruby
## assumes football.db datasets for England in ./england directory
##   see github.com/openfootball/england
SportDb.read( './england/2015-16/1-premierleague.txt' )

## let's try another season
SportDb.read( './england/2019-20/1-premierleague.txt' )
```

All leagues, seasons, clubs, match days and rounds, match fixtures and results,
and more are now in your (SQL) database of choice.





## More

### Articles

- [Working with CSV Files](articles/working-with-csv-files.md)
- [Working with CSV Packages](articles/working-with-csv-packages.md)
- [Generating Football JSON Datasets](articles/generating-json-datasets.md)


<!-- more -->

- [Working with Unicode](articles/working-with-unicode.md)



### HTTP JSON API Quick Starters

- [sport.db.starter](sport.db.starter) - Build Your Own HTTP JSON API (Ruby Edition)



## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)
