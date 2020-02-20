-- Use this as a hint. AVOID LOOKING AT THE SOLUTION.
-- SELECT [Column names] 
-- FROM [table] [abbv]
-- JOIN [table2] [abbv2] ON abbv.prop = abbv2.prop WHERE [Conditions];

-- SELECT a.name, b.name FROM some_table a JOIN another_table b ON a.some_id = b.some_id;
-- SELECT a.name, b.name FROM some_table a JOIN another_table b ON a.some_id = b.some_id WHERE b.email = 'e@mail.com';

SELECT * FROM invoice inv
-- combine the two tables together
INNER JOIN invoice_line iline ON inv.invoice_id = iline.invoice_id
WHERE iline.unit_price > 0.99;

SELECT i.invoice_date, c.first_name, c.last_name, i.total FROM invoice i
INNER JOIN customer c ON c.customer_id = i.customer_id;

SELECT c.first_name, c.last_name, s.first_name, s.last_name FROM customer c
INNER JOIN employee e ON e.reports_to = i.support_rep_id;

SELECT al.title, ar.name FROM album al
INNER JOIN artist ar ON ar.artist_id = al.artist_id;

SELECT pt.track_id FROM playlist_track pt
INNER JOIN playlist pl ON pl.playlist_id = pt.playlist_id
WHERE pl.name = 'Music'

SELECT t.name FROM track t
INNER JOIN playlist_track pl ON pl.track_id = t.track_id
WHERE pl.playlist_id = 5;

-- track.track_id ---> playlist_track.track_id
-- playlist_track.playlist_id ---> playlist.playlist_id
SELECT t.name, pl.name FROM track t
INNER JOIN playlist_track plt ON t.track_id = plt.track_id
INNER JOIN playlist pl ON plt.playlist_id = pl.playlist_id;

-- track.album_id ---> album.album_id
-- track.genre_id ---> genre.genre_id
SELECT t.name, a.title FROM track t
INNER JOIN album a ON t.album_id = a.album_id
INNER JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';

-- Practice nested queries - Syntax Hint
-- SELECT [column names] 
-- FROM [table] 
-- WHERE column_id IN ( SELECT column_id FROM [table2] WHERE [Condition] );

-- SELECT name, Email FROM Athlete WHERE AthleteId IN ( SELECT PersonId FROM PieEaters WHERE Flavor='Apple' );

SELECT * FROM invoice
-- It's not =. It's IN. 
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99);

SELECT * FROM playlist_track
WHERE playlist_id IN (SELECT playlist_id FROM playlist WHERE name = 'Music');

SELECT * FROM track
WHERE genre_id IN (SELECT genre_id FROM genre WHERE name = 'Comedy');

SELECT * FROM track
WHERE album_id IN (SELECT album_id FROM album WHERE title = 'Fireball');

--  track.album_id --> album.album_id
--  album.artist_id --> artist.artist_id --> get artist name via id
SELECT * FROM track
WHERE album_id IN ( 
   SELECT album_id FROM album WHERE artist_id IN ( 
      SELECT artist_id FROM artist WHERE name = 'Queen'
   )
); 

--  Group by - Syntax Hint
-- SELECT [column1], [column2]
-- FROM [table] [abbr]
-- GROUP BY [column];

SELECT g.name, COUNT(*) FROM track t
INNER JOIN genre g ON g.genre_id = t.genre_id
-- groups rows that have the same values into summary rows; in this case, for each name of genre,
-- get how many tracks that share the same name of genre.
GROUP BY g.name;

SELECT g.name, COUNT(*) FROM track t
INNER JOIN genre g ON g.genre_id = t.genre_id
-- Position matters in queries. In this case, WHERE being AFTER GROUP BY will cause an error.
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

SELECT art.name, COUNT(*) FROM album alb
INNER JOIN artist art ON art.artist_id = alb.artist_id
GROUP BY art.name;

-- Use Distinct - Syntax Hint
-- SELECT DISTINCT [column]
-- FROM [table];

-- Distinct gives all the different values for column specified
SELECT DISTINCT composer FROM track;

SELECT DISTINCT billing_postal_code FROM invoice;

SELECT DISTINCT company FROM customer;

-- Delete Rows - A hint isn't necessary.

DELETE FROM practice_delete WHERE type = 'bronze';

DELETE FROM practice_delete WHERE type = 'silver';

DELETE FROM practice_delete WHERE value = 150;

-- eCommerce Simulation

CREATE TABLE users (
   user_id SERIAL PRIMARY KEY, 
   username VARCHAR(10), 
   email VARCHAR(50)
);

CREATE TABLE product (
   product_id SERIAL PRIMARY KEY,
   product_name VARCHAR(20),
   product_price DECIMAL(10, 2)
);

CREATE TABLE orders (
   order_id SERIAL PRIMARY KEY,
   product_id INTEGER REFERENCES product(product_id),
   user_id INTEGER REFERENCES users(user_id)
);

INSERT INTO users (username, email)
VALUES ('hahargh', 'boop@mail.com');
INSERT INTO users (username, email)
VALUES ('oops', 'nope@mail.com');
INSERT INTO users (username, email)
VALUES ('food', 'allnope@mail.com');

INSERT INTO product (product_name, product_price)
VALUES ('banana', 0.49);
INSERT INTO product (product_name, product_price)
VALUES ('0.59', 0.59);
INSERT INTO product (product_name, product_price)
VALUES ('coke', 0.50);

INSERT INTO orders (product_id, user_id)
VALUES (2, 1);
INSERT INTO orders (product_id, user_id)
VALUES (3, 2);
INSERT INTO orders (product_id, user_id)
VALUES (1, 3);

SELECT * FROM orders WHERE order_id = 1;
SELECT * FROM orders;
SELECT SUM(p.product_price) FROM orders o
INNER JOIN product p ON p.product_id = o.product_id;

SELECT * FROM orders WHERE user_id = (SELECT user_id FROM users WHERE user_id = 1);

SELECT u.username, COUNT(*) FROM orders o
INNER JOIN users u ON u.user_id = o.user_id
GROUP BY u.username;