# COMP3311 22T1 Ass2 ... print info about different releases for Movie

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
	argument = sys.argv[1]

# manipulate database

query = """

SELECT
	rating,
	title,
	start_year
FROM Movies
WHERE title ~* '%s'
ORDER BY rating DESC, start_year ASC;

"""

try:
	db = psycopg2.connect("dbname=imdb")
	cur = db.cursor()
	cur.execute(query, argument)
	movielist = cur.fetchall()

	# ... add your code here ...

except psycopg2.Error as err:
	print("DB error: ", err)
finally:
	if db:
		db.close()
