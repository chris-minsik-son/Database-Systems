# Internet Movie Database (IMDB) Assignment
[🍦 View My Profile](https://github.com/chris-minsik-son)
[🍰 View Repositories](https://github.com/chris-minsik-son?tab=repositories)

## Table of Contents
  - [Aims](#aims)
  - [Introduction](#introduction)
  - [Questions](#questions)

## Aims

This assignment aims to give you practice in

* manipulating a moderately large database (IMDB)
* implementing SQL views to satisfy requests for information
* implementing PLpgSQL functions to satisfy requests for information
* implementing Python scripts to extract and display data

The goal is to build some useful data access operations on the Internet Movie Database (IMDB), which contains a wealth of information about movies, actors, etc. You need to write Python scripts, using the Psycopg2 database connectivity module, to extract and display information from this database.

## Introduction

The Internet Movie Database (IMDB) is a huge collection of information about all kinds of video media. It has data about most movies since the dawn of cinema, but also a vast amount of information about TV series, documentaries, short films, etc. Similarly, it holds information about the people who worked on and starred in these video artefacts. It also hold viewer ratings and crticis reviews for video artefacts as well as a host of other trivia (e.g. bloopers).

The full IMDB database is way too large to let you all build copies of it, so we have have created a cut-down version of the database that deals with well-rated movies from the last 60 years. You can find more details on the database schema in the [Database Design] page.

Some comments about the data in our copy of IMDB: there seems to be preponderance of recent Bollywood movies; some of the aliases look incorrect (e.g. for "Shawshank Redemption"); the data only goes to mid 2019, so you won't find recent blockbusters.

## Questions
1. Complete the script called "q1.py" so that it prints a list of the top N people who have directed the most movies (default N = 10). The script takes a single command-line argument which specifies how many people should appear in the list. People should be ordered from largest to smallest by the number of movies he/she directed, and should be displayed as, e.g.

```python
vxdb$ python3 q1.py 5
48 Woody Allen
40 Takashi Miike
39 Jean-Luc Godard
37 Claude Chabrol
36 Martin Scorsese

```

Within groups of people with the same number of movies, people should be ordered alphabetically by his/her name (Names.name). If the user supplies a number less than 1, print the following message and exit.

```python
vxdb$ python3 q1.py 0
Usage: q1.py [N]
```

For more examples of how the script behaves, see [Sample Outputs].

2. Complete the script called "q2.py" so that it prints a list of the different releases (different regions, different languages) for a movie. The script takes a single command-line argument which gives a part of a movie name (could be the entire name or a pattern). If no argument is given, print the following message and exit.

```python
vxdb$ python3 q2.py
Usage: q2.py 'PartialMovieTitle'
```

If there are no movies matching the supplied partial-name, then you should print a message to this effect and quit the program, e.g.

```python
vxdb$ python3 q2.py xyzzy
No movie matching 'xyzzy'
```

If the partial-name matches multiple movies, simply print a list of matching movies (rating, title, year of release), ordered by rating (highest to lowest), then year of release (earliest to latest) and then by title (alphabetical order), e.g.

```
vxdb$ python3 q2.py mothra
Movies matching 'mothra'
===============
7.1 Godzilla, Mothra and King Ghidorah: Giant Monsters All-Out Attack (2001)
6.6 Mothra (1961)
6.5 Mothra vs. Godzilla (1964)
6.2 Godzilla and Mothra: The Battle for Earth (1992)
```

If the partial name matches exactly one movie, then print that movie's title and year, and then print a list of all of the other releases (aliases) of the movie. If there are no aliases, print "Title (Year) has no alternative releases". For each alias, show at least the title. If a region exists, add this, and if a language is specified, add it as well, e.g.,

```
vxdb$ python3 q2.py 2001
2001: A Space Odyssey (1968) was also released as
'2001' (region: XWW, language: en)
'Two Thousand and One: A Space Odyssey' (region: US)
'2001: Odisea del espacio' (region: UY)
'2001: Een zwerftocht in de ruimte' (region: NL)
```

Movie releases should be ordered accoring to the ordering attribute in the Aliases table.

If an alias has no region or language, then put the string in the extra_info field in the parentheses. If it has neither region, language or extra info, just print the local title (without parentheses).

Note that if there are two movies with exactly the same original title, you will not be able to view their releases, since the title alone does not distinguish them. We consider this problem in the next question. Such tests will not be covered in this question.

For more examples of how the script behaves, see [Sample Outputs].