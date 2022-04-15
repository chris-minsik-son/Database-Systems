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