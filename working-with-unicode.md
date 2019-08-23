
# Working with Unicode Characters Beyond A to Z (Basic Latin 7-Bit Characters) - Let's Go International! Let's Go World-Wide!


Trivia Quiz: How many letters has the basic latin 7-bit alphabet
or using the more common name, that is, the English alphabet?

- (A)  24
- (B)  26
- (C)  28
- (D)  Other - Please, tell.

And the answer is ...  Let's ask the ruby oracle:

``` ruby
('A'..'Z').to_a.size
#=> 26
('A'..'Z').to_a.join
#=> "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
```

Let's go international! Let's go global! Let's go world wide!

Let's use unicode characters and start with internationalization (i18n).
Let's use the 1500+ football club names from
the [open football.db clubs](https://github.com/openfootball/clubs) dataset.

``` ruby
require 'footballdb/clubs'

Club.all.size
#=> 1716
```

Football club names include:
İnter Bakı PİK · Neftçi PFK · Qarabağ FK · Xäzär Länkäran FK ·
FC København · FC Vestsjælland ·
JJK Jyväskylä ·
LB Châteauroux · Évian TG FC ·
Bayern München ·  1. FC Köln · Preußen Münster ·
Widzew Łódź · Zagłębie Lubin ·
São Paulo FC · Atlético MG · EC Vitória ·
and many more.


Triva Quiz: How many extra letters have the 1500+ clubs names
beyond the basic latin 7-bit alphabet?

- (A)  13
- (B)  33
- (C)  63
- (D)  Other - Please, tell.

And the answer is ...  Let's ask the ruby oracle
and calculate the character frequency / usage:

``` ruby
freq = Hash.new(0)

clubs.each do |club|
  names = [club.name]+club.alt_names
  names.each do |name|
    ## calculate the frequency table of letters, digits, etc.
    name.each_char do |ch|
      next if ch.ord < 127     ## skip 7-bit basic latin letters, numbers, punctuations, etc.
      next if ch =~ /[º]/      ## skip some 8-bit special non-letter chars too
      freq[ch] += 1
    end
  end
end

freq.keys.size
#=> 63
freq.keys.sort.join
#=> ÁÅÇÉÍÖÚßàáâãäåæçèéêëíîñóôõöøúüýþāăąćČčėęğīİıŁłńňőřŚŞşŠšţūźżŽžșț
```

Wow. That's 63 more capital and small characters (!).
Did you know? Yes, there's a capital I with a dot `İ`
and there's a small i without a dot `ı` and on and on.

Let's start from the beginning...

Trivia Quiz: What's the official unicode name for `Á`?

- (A) LATIN CAPITAL LETTER A WITH GRAVE
- (B) LATIN CAPITAL LETTER A WITH ACUTE
- (C) LATIN CAPITAL LETTER A WITH DIAERESIS
- (D) LATIN CAPITAL LETTER A WITH CIRCUMFLEX


And the answer is ...  Let's ask the ruby oracle:

``` ruby
Unicode::Name.of( 'Á' )
#=> "LATIN CAPITAL LETTER A WITH ACUTE"
```

Now if you wonder where is this wonderful `Unicode::Name.of` helper coming from?
Let's thank Jan Lelis who dreams in Unicode
(and of [Idiosyncratic Ruby](https://idiosyncratic-ruby.com) fame)
for the great unicode gem / library family
that includes the  `unicode-name` gem / library
that returns the official Unicode name for a character / codepoint.

``` ruby
require 'unicode/name'

Unicode::Name.of( 'İ' )
#=> "LATIN CAPITAL LETTER I WITH DOT ABOVE"
Unicode::Name.of( 'ı' )
#=> "LATIN SMALL LETTER DOTLESS I"
```

See [`janlelis/unicode-name`](https://github.com/janlelis/unicode-name) for more documentation and how to use the unicode library / gem.

To wrap up - let's print all Unicode names and codepoints for the 63 characters
beyond the basic 7-bit Latin alphabet:

``` ruby
freq.keys.sort.each do |key|
  name = Unicode::Name.of( key )
  puts "#{key} - U+#{'%04X' % key.ord} (#{key.ord}) - #{name}"
end

```

resulting in:

```
Á - U+00C1 (193) - LATIN CAPITAL LETTER A WITH ACUTE
Å - U+00C5 (197) - LATIN CAPITAL LETTER A WITH RING ABOVE
Ç - U+00C7 (199) - LATIN CAPITAL LETTER C WITH CEDILLA
É - U+00C9 (201) - LATIN CAPITAL LETTER E WITH ACUTE
Í - U+00CD (205) - LATIN CAPITAL LETTER I WITH ACUTE
Ö - U+00D6 (214) - LATIN CAPITAL LETTER O WITH DIAERESIS
Ú - U+00DA (218) - LATIN CAPITAL LETTER U WITH ACUTE
ß - U+00DF (223) - LATIN SMALL LETTER SHARP S
à - U+00E0 (224) - LATIN SMALL LETTER A WITH GRAVE
á - U+00E1 (225) - LATIN SMALL LETTER A WITH ACUTE
â - U+00E2 (226) - LATIN SMALL LETTER A WITH CIRCUMFLEX
ã - U+00E3 (227) - LATIN SMALL LETTER A WITH TILDE
ä - U+00E4 (228) - LATIN SMALL LETTER A WITH DIAERESIS
å - U+00E5 (229) - LATIN SMALL LETTER A WITH RING ABOVE
æ - U+00E6 (230) - LATIN SMALL LETTER AE
ç - U+00E7 (231) - LATIN SMALL LETTER C WITH CEDILLA
è - U+00E8 (232) - LATIN SMALL LETTER E WITH GRAVE
é - U+00E9 (233) - LATIN SMALL LETTER E WITH ACUTE
ê - U+00EA (234) - LATIN SMALL LETTER E WITH CIRCUMFLEX
ë - U+00EB (235) - LATIN SMALL LETTER E WITH DIAERESIS
í - U+00ED (237) - LATIN SMALL LETTER I WITH ACUTE
î - U+00EE (238) - LATIN SMALL LETTER I WITH CIRCUMFLEX
ñ - U+00F1 (241) - LATIN SMALL LETTER N WITH TILDE
ó - U+00F3 (243) - LATIN SMALL LETTER O WITH ACUTE
ô - U+00F4 (244) - LATIN SMALL LETTER O WITH CIRCUMFLEX
õ - U+00F5 (245) - LATIN SMALL LETTER O WITH TILDE
ö - U+00F6 (246) - LATIN SMALL LETTER O WITH DIAERESIS
ø - U+00F8 (248) - LATIN SMALL LETTER O WITH STROKE
ú - U+00FA (250) - LATIN SMALL LETTER U WITH ACUTE
ü - U+00FC (252) - LATIN SMALL LETTER U WITH DIAERESIS
ý - U+00FD (253) - LATIN SMALL LETTER Y WITH ACUTE
þ - U+00FE (254) - LATIN SMALL LETTER THORN
ā - U+0101 (257) - LATIN SMALL LETTER A WITH MACRON
ă - U+0103 (259) - LATIN SMALL LETTER A WITH BREVE
ą - U+0105 (261) - LATIN SMALL LETTER A WITH OGONEK
ć - U+0107 (263) - LATIN SMALL LETTER C WITH ACUTE
Č - U+010C (268) - LATIN CAPITAL LETTER C WITH CARON
č - U+010D (269) - LATIN SMALL LETTER C WITH CARON
ė - U+0117 (279) - LATIN SMALL LETTER E WITH DOT ABOVE
ę - U+0119 (281) - LATIN SMALL LETTER E WITH OGONEK
ğ - U+011F (287) - LATIN SMALL LETTER G WITH BREVE
ī - U+012B (299) - LATIN SMALL LETTER I WITH MACRON
İ - U+0130 (304) - LATIN CAPITAL LETTER I WITH DOT ABOVE
ı - U+0131 (305) - LATIN SMALL LETTER DOTLESS I
Ł - U+0141 (321) - LATIN CAPITAL LETTER L WITH STROKE
ł - U+0142 (322) - LATIN SMALL LETTER L WITH STROKE
ń - U+0144 (324) - LATIN SMALL LETTER N WITH ACUTE
ň - U+0148 (328) - LATIN SMALL LETTER N WITH CARON
ő - U+0151 (337) - LATIN SMALL LETTER O WITH DOUBLE ACUTE
ř - U+0159 (345) - LATIN SMALL LETTER R WITH CARON
Ś - U+015A (346) - LATIN CAPITAL LETTER S WITH ACUTE
Ş - U+015E (350) - LATIN CAPITAL LETTER S WITH CEDILLA
ş - U+015F (351) - LATIN SMALL LETTER S WITH CEDILLA
Š - U+0160 (352) - LATIN CAPITAL LETTER S WITH CARON
š - U+0161 (353) - LATIN SMALL LETTER S WITH CARON
ţ - U+0163 (355) - LATIN SMALL LETTER T WITH CEDILLA
ū - U+016B (363) - LATIN SMALL LETTER U WITH MACRON
ź - U+017A (378) - LATIN SMALL LETTER Z WITH ACUTE
ż - U+017C (380) - LATIN SMALL LETTER Z WITH DOT ABOVE
Ž - U+017D (381) - LATIN CAPITAL LETTER Z WITH CARON
ž - U+017E (382) - LATIN SMALL LETTER Z WITH CARON
ș - U+0219 (537) - LATIN SMALL LETTER S WITH COMMA BELOW
ț - U+021B (539) - LATIN SMALL LETTER T WITH COMMA BELOW
```

Welcome to the Unicode wonderland
and to quote Jan Lelis: "Ruby ♡ Unicode".




Appendix:

For more about Ruby and Unicode, see the great Ruby ♡ Unicode series by Jan Lelis at the Idiosyncratic Ruby website:

- [Ruby has Character](https://idiosyncratic-ruby.com/66-ruby-has-character) - Ruby comes with good support for Unicode-related features. Read on if you want to learn more about important Unicode fundamentals and how to use them in Ruby...
- [Proper Unicoding](https://idiosyncratic-ruby.com/41-proper-unicoding) - Ruby's Regexp engine has a powerful feature built in: It can match for Unicode character properties. But what exactly are properties you can match for?
- [Regex with Class](https://idiosyncratic-ruby.com/30-regex-with-class) - Ruby's regex engine defines a lot of shortcut character classes. Besides the common meta characters (`\w`, etc.), there is also the POSIX style expressions and the unicode property syntax. This is an overview of all character classes...


<!--
   todo: add a section of unfolding and decomposing the characters
   to count how many a-z and how many accent characters?
   -- use a 2nd part article to make it a series - why? why not?
-->
