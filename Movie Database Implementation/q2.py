# COMP3311 22T1 Ass2 ... print info about different releases for Movie

from distutils.command.sdist import sdist
import sys
import psycopg2
import re

# define any local helper functions here

# set up some globals

usage = "Usage: q2.py 'PartialMovieTitle'"
db = None

# process command-line args

argc = len(sys.argv)

if len(sys.argv) == 1 or len(sys.argv) > 2:
	print(usage)
	sys.exit(1)
else:
	movietitle = sys.argv[1]

# manipulate database

moviequery = """

SELECT
	rating,
	title,
	start_year
FROM Movies
WHERE title ~* %s
ORDER BY rating DESC, start_year ASC;

"""

aliasquery = """

SELECT
	Movies.title,
	Aliases.local_title,
	Movies.start_year,
	Aliases.region,
	Aliases.language
FROM Movies
JOIN Aliases on (Movies.id = Aliases.movie_id)
WHERE Movies.title ~* %s
ORDER BY Aliases.ordering;

"""

# Ocean's Eleven

try:
	db = psycopg2.connect("dbname=imdb")
	cur = db.cursor()
	cur.execute(moviequery, [movietitle])
	movielist = cur.fetchall()

	# ... add your code here ...
	if len(movielist) == 0:
		print("No movie matching " + "'" + movietitle + "'")
	elif len(movielist) == 1:
		cur.execute(aliasquery, [movietitle])
		aliaslist = cur.fetchall()
		print(movietitle + " (" + str(movielist[0][2]) + ")" + " was also released as")
		for record in aliaslist:
			if record[4] is None:
				print("'" + record[1] + "' " + "(region: " + str(record[3]).rstrip() + ")")
			else:
				print("'" + record[1] + "' " + "(region: " + str(record[3]).rstrip() + ", language: " + str(record[4]).rstrip() + ")")
	else:
		print("Movies matching" + " '" + movietitle + "'")
		print("===============")
		for record in movielist:
			print(record[0], record[1], "("+ str(record[2])+ ")")
		
	# Update Aliases section, for when there are no alternative releases		



except psycopg2.Error as err:
	print("DB error: ", err)
finally:
	if db:
		db.close()
