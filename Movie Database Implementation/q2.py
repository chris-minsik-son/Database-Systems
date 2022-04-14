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
ORDER BY rating DESC, start_year, title;

"""

aliasquery = """

SELECT
	Movies.title,
	Aliases.local_title,
	Movies.start_year,
	Aliases.region,
	Aliases.language,
	Aliases.extra_info
FROM Movies
JOIN Aliases on (Movies.id = Aliases.movie_id)
WHERE Movies.title ~* %s
ORDER BY Aliases.ordering;

"""

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
		
		if len(aliaslist) == 0:
			print(movietitle + " (" + str(movielist[0][2]) + ")" + " has no alternative releases")
		else:
			print(movietitle + " (" + str(movielist[0][2]) + ")" + " was also released as")
			for record in aliaslist:
				if record[3] is None and record[4] is None and record[5] is not None:
					print("'" + record[1] + "' " + "(" + str(record[5]) + ")")
				if record[3] is not None and record[4] is None:
					print("'" + record[1] + "' " + "(region: " + str(record[3]).rstrip() + ")")
				elif record[3] is not None and record[4] is not None:
					print("'" + record[1] + "' " + "(region: " + str(record[3]).rstrip() + ", language: " + str(record[4]).rstrip() + ")")
		
	else:
		print("Movies matching" + " '" + movietitle + "'")
		print("===============")
		for record in movielist:
			print(record[0], record[1], "("+ str(record[2])+ ")")
		
except psycopg2.Error as err:
	print("DB error: ", err)
finally:
	if db:
		db.close()
