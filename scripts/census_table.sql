-- Database: hospital_readmission_server_dev

CREATE TABLE states(
  id SERIAL PRIMARY KEY,
  name varchar(255),
  population integer,
  abbrev varchar(2)
);

SELECT * FROM hospitals
LIMIT 1;

ALTER TABLE states
ADD CONSTRAINT state_fk
FOREIGN KEY (abbrev)
REFERENCES hospitals
(state) MATCH FULL;

SELECT name FROM states;







