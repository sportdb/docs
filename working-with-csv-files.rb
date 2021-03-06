require 'sportdb/text'

matches = CsvMatchReader.read( 'england/2010s/2019-20/eng.1.csv' )
pp matches.size
pp matches

standings = SportDb::Struct::Standings.new
standings.update( matches )
pp standings


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
