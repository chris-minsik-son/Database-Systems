-- 1. What beers are made by Toohey's?
SELECT name FROM beers WHERE brewer = 'Toohey''s';

-- 2. Show beers with headings "Beer", "Brewer".
SELECT
    name AS "Beer",
    brewer AS "Brewer"
FROM beers;

-- 3. How many different beers are there?
SELECT COUNT(DISTINCT name) FROM beers;

-- 4. How many different brewers are there?
SELECT COUNT(DISTINCT brewer) FROM beers;

-- 5. Which beers does John like?
SELECT beer FROM likes WHERE drinker = 'John';

-- 6. Find pairs of beers by the same manufacturer.
SELECT
    b1.name,
    b2.name,
    b1.brewer
FROM
    beers b1,
    beers b2
WHERE b1.brewer=b2.brewer AND b1.name < b2.name;

-- 7. How many beers does each brewer make?
SELECT brewer, COUNT(*)
FROM beers
GROUP BY brewer
ORDER BY COUNT DESC;

-- 8. Which brewers make only one beer?
SELECT
    brewer,
    COUNT(*)
FROM beers
GROUP BY brewer
HAVING COUNT(*) = 1;

-- 9. Which brewer makes the most beers?
-- My solution
SELECT brewer, COUNT(*)
FROM beers
GROUP BY brewer
ORDER BY COUNT DESC
LIMIT 1;

-- Lecturer's (alternative) solution
CREATE VIEW beertable(brewer, beercount)
AS SELECT brewer, COUNT(*) FROM beers GROUP BY brewer;

SELECT brewer, beercount
FROM beertable
WHERE beercount = (SELECT MAX(beercount) FROM beertable);
