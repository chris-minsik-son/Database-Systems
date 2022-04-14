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

try:
	db = psycopg2.connect("dbname=imdb")
	# ... add your code here ...
except psycopg2.Error as err:
	print("DB error: ", err)
finally:
	if db:
		db.close()

