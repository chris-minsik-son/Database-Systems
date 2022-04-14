# COMP3311 22T1 Ass2 ... get Name's biography/filmography

import sys
import psycopg2

# define any local helper functions here

# set up some globals

usage = "Usage: q4.py 'NamePattern' [Year]"
db = None

# process command-line args

argc = len(sys.argv)

if len(sys.argv) == 1:
	print(usage)
	sys.exit(1)
elif len(sys.argv) == 2:
	name = sys.argv[1]
	name = str(name)
	argcount = 1
elif len(sys.argv) == 3:
	name = sys.argv[1]
	name = str(name)
	birthyear = sys.argv[2]

	if birthyear.isnumeric() == True:
		birthyear = int(birthyear)
	else:
		print(usage)
		sys.exit(1)

	argcount = 2
else:
	print(usage)
	sys.exit(1)

# manipulate database

namelist = """

SELECT
	name,
	birth_year,
	death_year
FROM Names
WHERE name ~* %s
ORDER BY name;

"""

nameyearlist = """

SELECT
	name,
	birth_year,
	death_year
FROM Names
WHERE name ~* %s AND birth_year = %s
ORDER BY name;

"""


try:
	db = psycopg2.connect("dbname=imdb")
	cur = db.cursor()
	# ... add your code here ...

	# Check if valid name:
	if argcount == 1:
		cur.execute(namelist, [name])
		namelist = cur.fetchall()

		if len(namelist) == 0:
			print("No name matching " + "'" + name + "'")
			sys.exit(1)

	elif argcount == 2:
		cur.execute(nameyearlist, [name, birthyear])
		namelist = cur.fetchall()

		if len(namelist) == 0:
			print("No name matching " + "'" + name + "'" + " " + str(birthyear))
			sys.exit(1)

	# Construct profile for the single person matched:
	if argcount == 1 and len(namelist) == 1:
		# TO DO
		print("TO DO")

	# Print list of all matching names with birth year and death year in brackets:
	elif argcount == 1 and len(namelist) > 1:
		print("Names matching " + "'" + name + "'")
		print("===============")

		for record in namelist:
			if record[1] is None:
				print(record[0] + " (???)")
			elif record[2] is None:
				print(str(record[0]) + " (" + str(record[1]) + "-)")
			else:
				print(str(record[0]) + " (" + str(record[1]) + "-" + str(record[2]) + ")")
	
	elif argcount == 2 and len(namelist) == 1:
		# TO DO
		print("TO DO")

	elif argcount == 2 and len(namelist) > 1:
		print("Names matching " + "'" + name + "'")
		print("===============")

		for record in namelist:
			if record[1] is None:
				print(record[0] + " (???)")
			elif record[2] is None:
				print(str(record[0]) + " (" + str(record[1]) + "-)")
			else:
				print(str(record[0]) + " (" + str(record[1]) + "-" + str(record[2]) + ")")

except psycopg2.Error as err:
	print("DB error: ", err)
finally:
	if db:
		db.close()

