# Working with CSV Files


Let's build the standings table for the English Premier League (EPL) for the 2019/20 season from all 40 matches (as of Sept/2)
in the comma-separated values (.csv) format.
Example:

```
                                        - Home -          - Away -            - Total -
                                 Pld   W  D  L   F:A     W  D  L   F:A      F:A   +/-  Pts
 1. Liverpool FC                   4   2  0  0   7:2     2  0  0   5:1     12:3    +9   12
 2. Manchester City FC             4   1  1  0   6:2     2  0  0   8:1     14:3   +11   10
 3. Leicester City FC              4   1  1  0   3:1     1  1  0   3:2      6:3    +3    8
 4. Crystal Palace FC              4   1  1  0   1:0     1  0  1   2:2      3:2    +1    7
 5. Arsenal FC                     4   1  1  0   4:3     1  0  1   2:3      6:6          7
 6. Everton FC                     4   2  0  0   4:2     0  1  1   0:2      4:4          7
 7. West Ham United FC             4   1  0  1   2:5     1  1  0   4:2      6:7    -1    7
 8. Manchester United FC           4   1  0  1   5:2     0  2  0   2:2      7:4    +3    5
 9. Tottenham Hotspur FC           4   1  0  1   3:2     0  2  0   4:4      7:6    +1    5
10. Sheffield United FC            4   1  0  1   2:2     0  2  0   3:3      5:5          5
11. Chelsea FC                     4   0  2  0   3:3     1  0  1   3:6      6:9    -3    5
12. Burnley FC                     4   1  0  1   3:3     0  1  1   2:3      5:6    -1    4
13. Southampton FC                 4   0  1  1   2:3     1  0  1   2:3      4:6    -2    4
14. Newcastle United FC            4   0  1  1   1:2     1  0  1   2:3      3:5    -2    4
15. AFC Bournemouth                4   0  1  1   2:4     1  0  1   3:4      5:8    -3    4
16. Brighton & Hove Albion FC      4   0  1  1   1:3     1  0  1   3:4      4:7    -3    4
17. Wolverhampton Wanderers FC     4   0  2  0   2:2     0  1  1   2:3      4:5    -1    3
18. Aston Villa FC                 4   1  0  1   3:2     0  0  2   1:4      4:6    -2    3
19. Norwich City FC                4   1  0  1   5:4     0  0  2   1:6      6:10   -4    3
20. Watford FC                     4   0  0  2   1:6     0  1  1   1:2      2:8    -6    1
```


Step 0: Download the free public domain [`/england`](https://github.com/footballcsv/england) dataset package / archive from the [football.csv org](https://footballcsv.github.io).

What's the comma-separated values (.csv) format?
It's the world's most popular tabular data interchange format in text.
Values are separated - surprise, surprise - by commas (that is, `,`).
One line is one record, that is, one match :-).
Example:

```
Liverpool FC,         4-1, 4-0, Norwich City FC
West Ham United FC,   0-5, 0-1, Manchester City FC
AFC Bournemouth,      1-1, 0-0, Sheffield United FC
Burnley FC,           3-0, 0-0, Southampton FC
Crystal Palace FC,    0-0, 0-0, Everton FC
Watford FC,           0-3, 0-1, Brighton & Hove Albion FC
Tottenham Hotspur FC, 3-1, 0-1, Aston Villa FC
Leicester City FC,    0-0, 0-0, Wolverhampton Wanderers FC
Newcastle United FC,  0-1, 0-0, Arsenal FC
Manchester United FC, 4-0, 1-0, Chelsea FC
...
```

Let's use the [`eng.1.csv`](https://github.com/footballcsv/england/blob/master/2010s/2019-20/eng.1.csv), that is, the English Premier League datafile in the `/2010s/2019-20` folder.
Read in all matches with the csv reader class from the sportdb-text library / gem:


``` ruby
require 'sportdb/text'

matches = CsvMatchReader.read( 'england/2010s/2019-20/eng.1.csv' )
pp matches.size
pp matches
```

will pretty print (pp):

```
40
[#<SportDb::Struct::Match
  @date="2019-08-09",
  @score1=4,
  @score1i=4,
  @score2=1,
  @score2i=0,
  @team1="Liverpool FC",
  @team2="Norwich City FC",
  @winner=1>,
 #<SportDb::Struct::Match
  @date="2019-08-10",
  @score1=0,
  @score1i=0,
  @score2=5,
  @score2i=1,
  @team1="West Ham United FC",
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
#<SportDb::Struct::Standings
 @lines=
  {"Liverpool FC"=>
    #<SportDb::Struct::StandingsLine
     @away_drawn=0,
     @away_goals_against=1,
     @away_goals_for=5,
     @away_lost=0,
     @away_played=2,
     @away_pts=6,
     @away_won=2,
     @drawn=0,
     @goals_against=3,
     @goals_for=12,
     @home_drawn=0,
     @home_goals_against=2,
     @home_goals_for=7,
     @home_lost=0,
     @home_played=2,
     @home_pts=6,
     @home_won=2,
     @lost=0,
     @played=4,
     @pts=12,
     @rank=nil,
     @team="Liverpool FC",
     @won=4>,
   "Norwich City FC"=>
    #<SportDb::Struct::StandingsLine
     @away_drawn=0,
     @away_goals_against=6,
     @away_goals_for=1,
     @away_lost=2,
     @away_played=2,
     @away_pts=0,
     @away_won=0,
     @drawn=0,
     @goals_against=10,
     @goals_for=6,
     @home_drawn=0,
     @home_goals_against=4,
     @home_goals_for=5,
     @home_lost=1,
     @home_played=2,
     @home_pts=3,
     @home_won=1,
     @lost=3,
     @played=4,
     @pts=3,
     @rank=nil,
     @team="Norwich City FC",
     @won=1>,  ...>
```

Now let's format the standings for humans :-) in the classic more compact table format.
Let's start with
showing only totals - no home/away break outs yet -
in the first simple version:

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
 1. Liverpool FC                   4   4   0   0  12:3    12
 2. Manchester City FC             4   3   1   0  14:3    10
 3. Leicester City FC              4   2   2   0   6:3     8
 4. Crystal Palace FC              4   2   1   1   3:2     7
 5. Arsenal FC                     4   2   1   1   6:6     7
 6. Everton FC                     4   2   1   1   4:4     7
 7. West Ham United FC             4   2   1   1   6:7     7
 8. Manchester United FC           4   1   2   1   7:4     5
 9. Tottenham Hotspur FC           4   1   2   1   7:6     5
10. Sheffield United FC            4   1   2   1   5:5     5
11. Chelsea FC                     4   1   2   1   6:9     5
12. Burnley FC                     4   1   1   2   5:6     4
13. Southampton FC                 4   1   1   2   4:6     4
14. Newcastle United FC            4   1   1   2   3:5     4
15. AFC Bournemouth                4   1   1   2   5:8     4
16. Brighton & Hove Albion FC      4   1   1   2   4:7     4
17. Wolverhampton Wanderers FC     4   0   3   1   4:5     3
18. Aston Villa FC                 4   1   0   3   4:6     3
19. Norwich City FC                4   1   0   3   6:10    3
20. Watford FC                     4   0   1   3   2:8     1
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
 1. Liverpool FC                   4   2  0  0   7:2     2  0  0   5:1     12:3    +9   12
 2. Manchester City FC             4   1  1  0   6:2     2  0  0   8:1     14:3   +11   10
 3. Leicester City FC              4   1  1  0   3:1     1  1  0   3:2      6:3    +3    8
 4. Crystal Palace FC              4   1  1  0   1:0     1  0  1   2:2      3:2    +1    7
 5. Arsenal FC                     4   1  1  0   4:3     1  0  1   2:3      6:6          7
 6. Everton FC                     4   2  0  0   4:2     0  1  1   0:2      4:4          7
 7. West Ham United FC             4   1  0  1   2:5     1  1  0   4:2      6:7    -1    7
 8. Manchester United FC           4   1  0  1   5:2     0  2  0   2:2      7:4    +3    5
 9. Tottenham Hotspur FC           4   1  0  1   3:2     0  2  0   4:4      7:6    +1    5
10. Sheffield United FC            4   1  0  1   2:2     0  2  0   3:3      5:5          5
11. Chelsea FC                     4   0  2  0   3:3     1  0  1   3:6      6:9    -3    5
12. Burnley FC                     4   1  0  1   3:3     0  1  1   2:3      5:6    -1    4
13. Southampton FC                 4   0  1  1   2:3     1  0  1   2:3      4:6    -2    4
14. Newcastle United FC            4   0  1  1   1:2     1  0  1   2:3      3:5    -2    4
15. AFC Bournemouth                4   0  1  1   2:4     1  0  1   3:4      5:8    -3    4
16. Brighton & Hove Albion FC      4   0  1  1   1:3     1  0  1   3:4      4:7    -3    4
17. Wolverhampton Wanderers FC     4   0  2  0   2:2     0  1  1   2:3      4:5    -1    3
18. Aston Villa FC                 4   1  0  1   3:2     0  0  2   1:4      4:6    -2    3
19. Norwich City FC                4   1  0  1   5:4     0  0  2   1:6      6:10   -4    3
20. Watford FC                     4   0  0  2   1:6     0  1  1   1:2      2:8    -6    1
```


That's it.
Bonus: Why not build a standings table for the Bundesliga, La Liga, Ligue 1, Seria A, or your very own league? Yes, you can.
