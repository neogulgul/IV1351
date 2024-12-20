# IV1351
## Seminar 2
Files are found in the `Seminar_2` directory.
`tables.sql` creates the tables and `data.sql` inserts some data into said tables.
`testing.sql` is just there to see if stuff works as intended, and `main.sql` combines all three to make the testing process easier.

## Seminar 3
Files are found in the `Seminar_3` directory.
### Setup
First make sure you have a database setup. This can be done in a PostgreSQL environment with:
```
CREATE DATABASE <NAME_OF_DATABASE>;
```
Then switch into that database with:
```
\c <NAME_OF_DATABASE>
```
### Create tables with `tables.sql`
In a PostgreSQL environment run:
```
\i tables.sql
```
### Insert data with `data.sql`
In a PostgreSQL environment run:
```
\i data.sql
```
### Queries
The queries are placed in a folder called `queries` and can be run with:
```
\i queries/<SCRIPT>.sql
```
### All-in-One
We used a script to do all this for us to speed up the process during development. That script is `main.sql` and it creates a database called `soundgood` for you, in addition to creating tables, inserting data, and running queries.
In a PostgreSQL environment run:
```
\i main.sql
```
