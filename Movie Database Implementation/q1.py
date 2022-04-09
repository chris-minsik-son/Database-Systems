# COMP3311 22T1 Ass2 ... print num_of_movies, name of top N people with most movie directed

import sys
import psycopg2
import re

# define any local helper functions here

# set up some globals

usage = "Usage: q1.py [N]"
db = None

# process command-line args

argc = len(sys.argv)

if len(sys.argv) == 1:
	N = 10
	N = str(N)
else:
	N = sys.argv[1]


# manipulate database

query = """

SELECT
	Names.name,
	COUNT(*) as count
FROM crew_roles
JOIN Names on (crew_roles.name_id = Names.id)
WHERE crew_roles.role = 'director'
GROUP BY Names.name
ORDER BY count DESC;

"""

try:
	db = psycopg2.connect("dbname=imdb")
	cur = db.cursor()
	cur.execute(query, N)
	directors = cur.fetchall()

	# ... add your code here ...

	if not re.match("^[1-9]+$", N):
		print(usage)
		sys.exit(1)

	count = 0

	for record in directors:
		if count == int(N):
			break
		print(record[1], record[0])
		count = count + 1


except psycopg2.Error as err:
	print("DB error: ", err)
finally:
	if db:
		db.close()
