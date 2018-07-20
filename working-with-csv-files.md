# Working with CSV Files


Let's build the standings table for the English Premier League (EPL) for the 2017/18 season from all 380 matches in the comma-seaprated values (.csv) format.
Example:

```
                                        - Home -          - Away -            - Total -
                                 Pld   W  D  L   F:A     W  D  L   F:A      F:A   +/-  Pts
 1. Manchester City FC            38  16  2  1  61:14   16  2  1  45:13   106:27  +79  100
 2. Manchester United FC          38  15  2  2  38:9    10  4  5  30:19    68:28  +40   81
 3. Tottenham Hotspur FC          38  13  4  2  40:16   10  4  5  34:20    74:36  +38   77
 4. Liverpool FC                  38  12  7  0  45:10    9  5  5  39:28    84:38  +46   75
 5. Chelsea FC                    38  11  4  4  30:16   10  3  6  32:22    62:38  +24   70
 6. Arsenal FC                    38  15  2  2  54:20    4  4 11  20:31    74:51  +23   63
 7. Burnley FC                    38   7  5  7  16:17    7  7  5  20:22    36:39   -3   54
 8. Everton FC                    38  10  4  5  28:22    3  6 10  16:36    44:58  -14   49
 9. Leicester City FC             38   7  6  6  25:22    5  5  9  31:38    56:60   -4   47
10. Newcastle United FC           38   8  4  7  21:17    4  4 11  18:30    39:47   -8   44
11. Crystal Palace FC             38   7  5  7  29:27    4  6  9  16:28    45:55  -10   44
12. AFC Bournemouth               38   7  5  7  26:30    4  6  9  19:31    45:61  -16   44
13. West Ham United FC            38   7  6  6  24:26    3  6 10  24:42    48:68  -20   42
14. Watford FC                    38   7  6  6  27:31    4  2 13  17:33    44:64  -20   41
15. Brighton & Hove Albion FC     38   7  8  4  24:25    2  5 12  10:29    34:54  -20   40
16. Huddersfield Town AFC         38   6  5  8  16:25    3  5 11  12:33    28:58  -30   37
17. Southampton FC                38   4  7  8  20:26    3  8  8  17:30    37:56  -19   36
18. Swansea City AFC              38   6  3 10  17:24    2  6 11  11:32    28:56  -28   33
19. Stoke City FC                 38   5  5  9  20:30    2  7 10  15:38    35:68  -33   33
20. West Bromwich Albion FC       38   3  9  7  21:29    3  4 12  10:27    31:56  -25   31
```


Step 0: Download the free public domain [`/eng-england`](https://github.com/footballcsv/eng-england) dataset package / archive from the [football.csv org](https://footballcsv.github.io).

What's the comma-separated values (.csv) format?

It's the world's most popular tabular data interchange format in text.
Values are separated - surprise, surprise - by commas (that is, `,`).
One line is one record (that is, one match :-)).
Example:

```
Arsenal,              1-3, 1-1, Aston Villa
Liverpool,            1-0, 1-0, Stoke City
Norwich City,         2-2, 0-0, Everton
Sunderland,           0-1, 0-0, Fulham
Swansea City,         1-4, 0-2, Manchester United
West Bromwich Albion, 0-1, 0-0, Southampton
West Ham United,      2-0, 1-0, Cardiff City
Chelsea,              2-0, 2-0, Hull City
Crystal Palace,       0-1, 0-0, Tottenham Hotspur
Manchester City,      4-0, 2-0, Newcastle United
...
```

Let's use the [`1-premierleague.csv`](https://github.com/footballcsv/eng-england/blob/master/2010s/2017-18/1-premierleague.csv) datafile in the `/2010s/2017-18` folder.
Read in the all matches with the csv reader class from the sportdb-text library / gem.


``` ruby
require 'sportdb/text'

matches = CsvMatchReader.read( 'eng-england/2010s/2017-18/1-premierleague.csv' )
pp matches.size
pp matches
```

will pretty print (pp):

```
380
[#<SportDb::Struct::Match:0x2993820
  @date="2017-08-11",
  @score1=4,
  @score1i=2,
  @score2=3,
  @score2i=2,
  @team1="Arsenal FC",
  @team2="Leicester City FC",
  @winner=1>,
 #<SportDb::Struct::Match:0x2992758
  @date="2017-08-12",
  @score1=0,
  @score1i=0,
  @score2=2,
  @score2i=0,
  @team1="Brighton & Hove Albion FC",
  @team2="Manchester City FC",
  @winner=2>,
  ...]
```

Now tally up all matches for the standings table with the standings helper class:

``` ruby
standings = SportDb::Struct::Standings.new
standings.update( matches )
pp standings
```

will pretty print (pp):

```
#<SportDb::Struct::Standings:0x26573e8
 @lines=
  {"Arsenal FC"=>
    #<SportDb::Struct::StandingsLine:0x2657370
     @away_drawn=4,
     @away_goals_against=31,
     @away_goals_for=20,
     @away_lost=11,
     @away_played=19,
     @away_pts=16,
     @away_won=4,
     @drawn=6,
     @goals_against=51,
     @goals_for=74,
     @home_drawn=2,
     @home_goals_against=20,
     @home_goals_for=54,
     @home_lost=2,
     @home_played=19,
     @home_pts=47,
     @home_won=15,
     @lost=13,
     @played=38,
     @pts=63,
     @rank=nil,
     @team="Arsenal FC",
     @won=19>,
   "Leicester City FC"=>
    #<SportDb::Struct::StandingsLine:0x2657358
     @away_drawn=5,
     @away_goals_against=38,
     @away_goals_for=31,
     @away_lost=9,
     @away_played=19,
     @away_pts=20,
     @away_won=5,
     @drawn=11,
     @goals_against=60,
     @goals_for=56,
     @home_drawn=6,
     @home_goals_against=22,
     @home_goals_for=25,
     @home_lost=6,
     @home_played=19,
     @home_pts=27,
     @home_won=7,
     @lost=15,
     @played=38,
     @pts=47,
     @rank=nil,
     @team="Leicester City FC",
     @won=12>, ...>
```

Now let's format the standings for humans :-) in the classic compact table format.
Let's start with
showing only totals - no home/away break outs yet -
in the first simple version / try:

``` ruby
standings.to_a.each do |l|
  print '%2d. '     % l.rank
  print '%-28s  '   % l.team
  print '%2d '      % l.played
  print '%3d '      % l.won
  print '%3d '      % l.drawn
  print '%3d '      % l.lost
  print '%3d:%-3d ' % [l.goals_for,l.goals_against]
  print '%3d'       % l.pts
  print "\n"
end
```

resulting in:

```
 1. Manchester City FC            38  32   4   2 106:27  100
 2. Manchester United FC          38  25   6   7  68:28   81
 3. Tottenham Hotspur FC          38  23   8   7  74:36   77
 4. Liverpool FC                  38  21  12   5  84:38   75
 5. Chelsea FC                    38  21   7  10  62:38   70
 6. Arsenal FC                    38  19   6  13  74:51   63
 7. Burnley FC                    38  14  12  12  36:39   54
 8. Everton FC                    38  13  10  15  44:58   49
 9. Leicester City FC             38  12  11  15  56:60   47
10. Newcastle United FC           38  12   8  18  39:47   44
11. Crystal Palace FC             38  11  11  16  45:55   44
12. AFC Bournemouth               38  11  11  16  45:61   44
13. West Ham United FC            38  10  12  16  48:68   42
14. Watford FC                    38  11   8  19  44:64   41
15. Brighton & Hove Albion FC     38   9  13  16  34:54   40
16. Huddersfield Town AFC         38   9  10  19  28:58   37
17. Southampton FC                38   7  15  16  37:56   36
18. Swansea City AFC              38   8   9  21  28:56   33
19. Stoke City FC                 38   7  12  19  35:68   33
20. West Bromwich Albion FC       38   6  13  19  31:56   31
```

To wrap up let's break out the standings for home and away matches for a deluxe version:

``` ruby
print "                                        - Home -          - Away -            - Total -\n"
print "                                 Pld   W  D  L   F:A     W  D  L   F:A      F:A   +/-  Pts\n"

standings.to_a.each do |l|
  print '%2d. '  % l.rank
  print '%-28s  ' % l.team
  print '%2d  '     % l.played

  print '%2d '      % l.home_won
  print '%2d '      % l.home_drawn
  print '%2d '      % l.home_lost
  print '%3d:%-3d  ' % [l.home_goals_for,l.home_goals_against]

  print '%2d '       % l.away_won
  print '%2d '       % l.away_drawn
  print '%2d '       % l.away_lost
  print '%3d:%-3d  ' % [l.away_goals_for,l.away_goals_against]

  print '%3d:%-3d ' % [l.goals_for,l.goals_against]

  goals_diff = l.goals_for-l.goals_against
  if goals_diff > 0
    print '%3s  '  %  "+#{goals_diff}"
  elsif goals_diff < 0
    print '%3s  '  %  "#{goals_diff}"
  else ## assume 0
    print '     '
  end

  print '%3d'  % l.pts
  print "\n"
end
```

resulting in:

```
                                        - Home -          - Away -            - Total -
                                 Pld   W  D  L   F:A     W  D  L   F:A      F:A   +/-  Pts
 1. Manchester City FC            38  16  2  1  61:14   16  2  1  45:13   106:27  +79  100
 2. Manchester United FC          38  15  2  2  38:9    10  4  5  30:19    68:28  +40   81
 3. Tottenham Hotspur FC          38  13  4  2  40:16   10  4  5  34:20    74:36  +38   77
 4. Liverpool FC                  38  12  7  0  45:10    9  5  5  39:28    84:38  +46   75
 5. Chelsea FC                    38  11  4  4  30:16   10  3  6  32:22    62:38  +24   70
 6. Arsenal FC                    38  15  2  2  54:20    4  4 11  20:31    74:51  +23   63
 7. Burnley FC                    38   7  5  7  16:17    7  7  5  20:22    36:39   -3   54
 8. Everton FC                    38  10  4  5  28:22    3  6 10  16:36    44:58  -14   49
 9. Leicester City FC             38   7  6  6  25:22    5  5  9  31:38    56:60   -4   47
10. Newcastle United FC           38   8  4  7  21:17    4  4 11  18:30    39:47   -8   44
11. Crystal Palace FC             38   7  5  7  29:27    4  6  9  16:28    45:55  -10   44
12. AFC Bournemouth               38   7  5  7  26:30    4  6  9  19:31    45:61  -16   44
13. West Ham United FC            38   7  6  6  24:26    3  6 10  24:42    48:68  -20   42
14. Watford FC                    38   7  6  6  27:31    4  2 13  17:33    44:64  -20   41
15. Brighton & Hove Albion FC     38   7  8  4  24:25    2  5 12  10:29    34:54  -20   40
16. Huddersfield Town AFC         38   6  5  8  16:25    3  5 11  12:33    28:58  -30   37
17. Southampton FC                38   4  7  8  20:26    3  8  8  17:30    37:56  -19   36
18. Swansea City AFC              38   6  3 10  17:24    2  6 11  11:32    28:56  -28   33
19. Stoke City FC                 38   5  5  9  20:30    2  7 10  15:38    35:68  -33   33
20. West Bromwich Albion FC       38   3  9  7  21:29    3  4 12  10:27    31:56  -25   31
```


That's it.
Bonus: Why not build a standings table for the Bundesliga, La Liga, Ligue 1, Seria A, or your very own league? Yes, you can.
