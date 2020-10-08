
/*------- TRUNCATE --------*/

MATCH (n)
OPTIONAL MATCH (n)-[r]-(e)
DELETE n,r,e
;

