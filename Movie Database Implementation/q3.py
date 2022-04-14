# COMP3311 22T1 Ass2 ... print info about cast and crew for Movie

import sys
import psycopg2

# define any local helper functions here

# set up some globals

usage = "Usage: q3.py 'MovieTitlePattern' [Year]"
db = None

# process command-line args

argc = len(sys.argv)

if len(sys.argv) == 1:
	print(usage)
	sys.exit(1)
elif len(sys.argv) == 2:
	movietitle = sys.argv[1]
	movietitle = str(movietitle)
	argcount = 1
elif len(sys.argv) == 3:
	movietitle = sys.argv[1]
	movietitle = str(movietitle)
	movieyear = sys.argv[2]

	if movieyear.isnumeric() == True:
		movieyear = int(movieyear)
	else:
		print(usage)
		sys.exit(1)

	argcount = 2
else:
	print(usage)
	sys.exit(1)

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

actorquery = """

SELECT
	Names.name,
	Acting_roles.played
FROM Acting_roles
JOIN Names on (Acting_roles.name_id = Names.id)
JOIN Movies on (Acting_roles.movie_id = Movies.id)
JOIN Principals on (Movies.id = Principals.movie_id AND Names.id = Principals.name_id)
WHERE Movies.title ~* %s
ORDER BY Principals.ordering, Acting_roles.played;

"""

crewquery = """

SELECT
	Names.name,
	Crew_roles.role
FROM Crew_roles
JOIN Movies on (Crew_roles.movie_id = Movies.id)
JOIN Names on (Crew_roles.name_id = Names.id)
JOIN Principals on (Movies.id = Principals.movie_id AND Names.id = Principals.name_id)
WHERE Movies.title ~* %s
ORDER BY Principals.ordering, Crew_roles.role;

"""

movieyearquery = """

SELECT
	rating,
	title,
	start_year
FROM Movies
WHERE title ~* %s AND start_year = %s
ORDER BY rating DESC, start_year, title;

"""

actoryearquery = """

SELECT
	Names.name,
	Acting_roles.played
FROM Acting_roles
JOIN Names on (Acting_roles.name_id = Names.id)
JOIN Movies on (Acting_roles.movie_id = Movies.id)
JOIN Principals on (Movies.id = Principals.movie_id AND Names.id = Principals.name_id)
WHERE Movies.title ~* %s AND Movies.start_year = %s
ORDER BY Principals.ordering, Acting_roles.played;

"""

crewyearquery = """

SELECT
	Names.name,
	Crew_roles.role
FROM Crew_roles
JOIN Movies on (Crew_roles.movie_id = Movies.id)
JOIN Names on (Crew_roles.name_id = Names.id)
JOIN Principals on (Movies.id = Principals.movie_id AND Names.id = Principals.name_id)
WHERE Movies.title ~* %s AND Movies.start_year = %s
ORDER BY Principals.ordering, Crew_roles.role;

"""

try:
	db = psycopg2.connect("dbname=imdb")
	cur = db.cursor()

	# ... add your code here ...
	
	# Check if valid movie name:
	if argcount == 1:
		cur.execute(moviequery, [movietitle])
		movielist = cur.fetchall()

		if len(movielist) == 0:
			print("No movie matching " + "'" + movietitle + "'")
			sys.exit(1)

	elif argcount == 2:
		cur.execute(movieyearquery, [movietitle, movieyear])
		movielist = cur.fetchall()

		if len(movielist) == 0:
			print("No movie matching " + "'" + movietitle + "'" + " " + str(movieyear))
			sys.exit(1)


	# If only one movie is given, return actors and crew members:
	if argcount == 1 and len(movielist) == 1:

		print(movielist[0][1] + " (" + str(movielist[0][2]) + ")")
		print("===============")
		print("Starring")

		cur.execute(actorquery, [movietitle])
		actorlist = cur.fetchall()
		
		for record in actorlist:
			print(" " + record[0] + " as " + record[1])
		
		print("and with")

		cur.execute(crewquery, [movietitle])
		crewlist = cur.fetchall()

		for record in crewlist:
			print(" " + record[0] + ": " + record[1].capitalize())

	elif argcount == 2 and len(movielist) == 1:

		print(movielist[0][1] + " (" + str(movielist[0][2]) + ")")
		print("===============")
		print("Starring")

		cur.execute(actoryearquery, [movietitle, movieyear])
		actorlist = cur.fetchall()
		
		for record in actorlist:
			print(" " + record[0] + " as " + record[1])
		
		print("and with")

		cur.execute(crewyearquery, [movietitle, movieyear])
		crewlist = cur.fetchall()

		for record in crewlist:
			print(" " + record[0] + ": " + record[1].capitalize())

	# If more than one movie is given, return list of matching movies
	elif argcount == 1 and len(movielist) > 1:
		cur.execute(moviequery, [movietitle])
		movielist = cur.fetchall()
		
		print("Movies matching" + " '" + movietitle + "'")
		print("===============")
		
		for record in movielist:
			print(record[0], record[1], "("+ str(record[2])+ ")")

	elif argcount == 2 and len(movielist) > 1:
		cur.execute(movieyearquery, [movietitle, movieyear])
		movielist = cur.fetchall()
		
		print("Movies matching" + " '" + movietitle + "'" + " " + str(movieyear))
		print("===============")
		
		for record in movielist:
			print(record[0], record[1], "("+ str(record[2])+ ")")

except psycopg2.Error as err:
	print("DB error: ", err)
finally:
	if db:
		db.close()
