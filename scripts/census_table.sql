-- Database: hospital_readmission_server_dev

ALTER TABLE states ADD CONSTRAINT abbrev_key UNIQUE (abbrev);

# create column for state ID
ALTER TABLE hospitals ADD COLUMN state_id integer;

# update hospitals
# state_id = s.id is an alias
UPDATE hospitals
SET state_id = s.id
FROM states s
WHERE state = s.abbrev;

SELECT * FROM states
ORDER BY name;

# add a foreign key
ALTER TABLE hospitals
ADD CONSTRAINT state_fk
FOREIGN KEY (state)
REFERENCES states
(abbrev) MATCH FULL;

# add a foreign key
ALTER TABLE hospitals
ADD CONSTRAINT state_idfk
FOREIGN KEY (state_id)
REFERENCES states
(id) MATCH FULL;

EXPLAIN ANALYZE
SELECT * FROM hospitals
INNER JOIN states ON (hospitals.state_id = states.id)
WHERE states.abbrev = 'WI';

SELECT * FROM hospitals
INNER JOIN states ON (hospitals.state = states.abbrev)
WHERE states.abbrev = 'WI';



VACUUM ANALYZE;
