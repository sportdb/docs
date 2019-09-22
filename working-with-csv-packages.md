# Working with CSV Packages


Let's import all English football leagues and matches (from 1888-89 to today)
from the [football.csv package](https://github.com/footballcsv/england) into an SQL database.

Let's start from zero / scratch and let's
create an empty `/import` directory / folder. Type:

```
$ mkdir import
```

## Step 0:   Setup - Install the Sport.db Libraries

Use Ruby's bundler to install all required libraries (gems)
and all dependencies.
Create a new `Gemfile` for bundler (in the `/import` directory / folder)
that lists the `sportdb-import` library (gem)
and bundler will figure out the rest.

``` ruby
source 'https://rubygems.org'

gem 'sportdb-import'

gem 'activerecord',  '~> 5.2'  ## workaround: latest version (6.0.0) requires ruby 2.4.4+
```

Now type / run:

```
$ bundle install
```

That will install all libraries and
bundler will print what libraries get used and installed on the console output
(and all versions get locked down and written into `Gemfile.lock`).
Example:

```
Fetching gem metadata from https://rubygems.org/.............
Fetching version metadata from https://rubygems.org/..
Resolving dependencies...
Using concurrent-ruby 1.1.5
Using minitest 5.11.3
Using thread_safe 0.3.6
Using arel 9.0.0
Using logutils 0.6.1
Using alphabets 0.1.0
Using bundler 1.15.3
Using csvjson 1.0.1
Using csvyaml 1.0.0
Using tabreader 1.0.1
Using iniparser 0.1.0
Using rubyzip 1.2.4
Using i18n 1.6.0
Using tzinfo 1.2.5
Using csvreader 1.2.4
Using props 1.2.0
Fetching activesupport 5.2.3
Installing activesupport 5.2.3
Using sportdb-countries 0.2.0
Fetching activemodel 5.2.3
Installing activemodel 5.2.3
Using textutils 1.4.0
Using fifa 1.0.0
Using sportdb-clubs 0.2.0
Using sportdb-leagues 0.1.0
Fetching activerecord 5.2.3
Installing activerecord 5.2.3
Using footballdb-clubs 1.0.0
Using activerecord-utils 0.4.0
Using logutils-activerecord 0.2.1
Using props-activerecord 0.2.0
Using tagutils 1.0.0
Using sportdb-config 0.8.0
Using worlddb-models 2.4.0
Using sportdb-text 0.3.3
Using persondb-models 0.5.0
Using sportdb-models 1.18.0
Using sportdb-import 0.2.4
Bundle complete! 2 Gemfile dependencies, 35 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

Bundle complete! Ready to go.


##  Step 1:   Download (or Clone) the CSV Package / Datasets

Let's download all English football leagues and matches (from 1888-89 to today)
from the [football.csv package](https://github.com/footballcsv/england).

Use / type / run:

```
$ git clone https://github.com/footballcsv/england.git
```

Resulting in and printing on the console:

```
Cloning into 'england'...
remote: Enumerating objects: 3740, done.
remote: Total 3740 (delta 0), reused 0 (delta 0), pack-reused 3740
Receiving objects: 100% (3740/3740), 7.83 MiB | 1.39 MiB/s, done.
Resolving deltas: 100% (1430/1430), done.
Checking out files: 100% (561/561), done.
```

And the `/import` directory / folder now looks like:

```
│   Gemfile
│   Gemfile.lock
│
└───england
    │   LICENSE.md
    │   README.md
    │   SOURCES.md
    │   SUMMARY.md
    │
    ├───1880s
    │   ├───1888-89
    │   │       eng.1.csv
    │   │       README.md
    │   │
    │   └───1889-90
    │           eng.1.csv
    │           README.md
    ...
    └───2019-20
                eng.1.csv
                eng.2.csv
                eng.3.csv
                eng.4.csv
                eng.5.csv
                README.md
```

Note: As an alternative you can download the zip-archive and unpack / unzip
the datasets "by hand".


##  Step 2:   Add the Import / Build Script

Let's add the missing import / build script.
Let's use `build.rb`. Example:

``` ruby
require 'sportdb/import'


SportDb.connect( adapter:  'sqlite3',
                 database: './eng.db' )

## build database schema / tables
SportDb.create_all

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)


## note: requires a local copy of the football.csv england datasets
##          see https://github.com/footballcsv/england
pack = CsvMatchImporter.new( './england' )
pack.import_leagues
```

And to kick off the import that builds the SQL database from the CSV datasets
run / type:

```
$ ruby ./build.rb
```

Stand back ten feet! Once the script runs through and is done you've got
a new SQLite `eng.db` database waiting for you with all English football leagues, clubs and matches (all the way back to 1888). That's it. Enjoy the beautiful game.



Note:  You can import the datasets to any SQL database (e.g. PostgreSQL, MySQL, etc.)
that `ActiveRecord` supports. To use a different database change the
`SportDb.connect` database configuration setup.
