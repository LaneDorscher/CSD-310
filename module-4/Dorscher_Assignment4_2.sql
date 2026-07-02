-- create DATABASE movies;

-- USE movies;

-- show DATABASEs;

use movies;

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    director VARCHAR(255) NOT NULL,
    release_year INT NOT NULL,
    genre VARCHAR(100) NOT NULL
);

create Table actors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    birth_year INT NOT NULL
);

create table movie_actors (
    movie_id INT,
    actor_id INT,
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (actor_id) REFERENCES actors(id)
);

insert into movies (title, director, release_year, genre) values
('Inception', 'Christopher Nolan', 2010, 'Science Fiction'),
('The Dark Knight', 'Christopher Nolan', 2008, 'Action'),
('Pulp Fiction', 'Quentin Tarantino', 1994, 'Crime'),
('The Shawshank Redemption', 'Frank Darabont', 1994, 'Drama'),
("The Knight's Tale", 'Brian Helgeland', 2001, 'Adventure');

insert into actors (name, birth_year) values
('Leonardo DiCaprio', 1974),
('Joseph Gordon-Levitt', 1981),
('Elliot Page', 1987),
('Christian Bale', 1974),
('Heath Ledger', 1979),
('John Travolta', 1954),
('Samuel L. Jackson', 1948),
('Tim Robbins', 1958),
('Morgan Freeman', 1937),
('Heath Ledger', 1979);

insert into movie_actors (movie_id, actor_id) values
(1, 1), -- Inception - Leonardo DiCaprio
(1, 2), -- Inception - Joseph Gordon-Levitt
(1, 3), -- Inception - Elliot Page
(2, 4), -- The Dark Knight - Christian Bale
(2, 5), -- The Dark Knight - Heath Ledger
(3, 6), -- Pulp Fiction - John Travolta
(3, 7), -- Pulp Fiction - Samuel L. Jackson
(4, 8), -- The Shawshank Redemption - Tim Robbins
(4, 9); -- The Shawshank Redemption - Morgan Freeman

select movie.title as MOVIE_TITLE, actor.name as ACTOR_NAME
from movies movie
join movie_actors ma on movie.id = ma.movie_id
join actors actor on ma.actor_id = actor.id;    