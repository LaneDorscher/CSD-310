## Author: Lane Dorscher
## Date: 07/22/2026
## Course: CSD-310
## Assignment: 7.2
## Description: This program connects to the movies database, displays
##              film records, inserts a film, updates Alien, and deletes
##              Gladiator.

import sys

import mysql.connector
from mysql.connector import errorcode
from dotenv import dotenv_values

# Database Setup / Config
## Load database settings from the .env file.
secrets = dotenv_values(".env")

DATABASE_CONFIG = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "port": int(secrets["PORT"]),
    "database": secrets["DATABASE"],
    "raise_on_warnings":
        secrets.get("RAISE_ON_WARNINGS", "true").lower() == "true"
}

## Queries

# MySQL queries

SELECT_FILMS_QUERY = """
    SELECT
        film.film_name AS Name,
        film.film_director AS Director,
        genre.genre_name AS Genre,
        studio.studio_name AS Studio
    FROM film
    INNER JOIN genre
        ON film.genre_id = genre.genre_id
    INNER JOIN studio
        ON film.studio_id = studio.studio_id
    ORDER BY film.film_id
"""

INSERT_FILM_QUERY = """
    INSERT INTO film (
        film_name,
        film_releaseDate,
        film_runtime,
        film_director,
        studio_id,
        genre_id
    )
    VALUES (
        %s,
        %s,
        %s,
        %s,
        (
            SELECT studio_id
            FROM studio
            WHERE studio_name = %s
        ),
        (
            SELECT genre_id
            FROM genre
            WHERE genre_name = %s
        )
    )
"""

UPDATE_FILM_GENRE_QUERY = """
    UPDATE film
    SET genre_id = (
        SELECT genre_id
        FROM genre
        WHERE genre_name = %s
    )
    WHERE film_name = %s
"""

DELETE_FILM_QUERY = """
    DELETE FROM film
    WHERE film_name = %s
"""




def show_films(cursor, title):
    """
    Displays the film name, director, genre, and studio for all films.

    :param cursor: Active MySQL database cursor.
    :param title: Label displayed above the film results.
    """

    cursor.execute(SELECT_FILMS_QUERY)
    films = cursor.fetchall()

    print(f"\n-- {title} --")

    for film in films:
        print(f"Film Name: {film[0]}")
        print(f"Director: {film[1]}")
        print(f"Genre Name: {film[2]}")
        print(f"Studio Name: {film[3]}")
        print()


def connect_database():
    """Connects to the MySQL movies database."""

    try:
        database = mysql.connector.connect(**DATABASE_CONFIG)

        print(
            f"\nDatabase user {DATABASE_CONFIG['user']} connected to "
            f"MySQL on host {DATABASE_CONFIG['host']} with database "
            f"{DATABASE_CONFIG['database']}."
        )

        return database

    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("The supplied username or password is invalid.")

        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("The specified database does not exist.")

        else:
            print(f"Database connection error: {err}")

        sys.exit(1)


def disconnect_database(database):
    """Disconnects from the MySQL database."""

    if database is not None and database.is_connected():
        database.close()
        print("Database connection closed.")


def main():
    """Application entry point."""

    database = None
    cursor = None

    try:
        database = connect_database()
        cursor = database.cursor()

        # Display the original film records.
        show_films(cursor, "DISPLAYING FILMS")

        # Insert a new film.

        new_film = (
            "The Martian",
            "2015",
            144,
            "Ridley Scott",
            "20th Century Fox",
            "SciFi"
        )

        cursor.execute(INSERT_FILM_QUERY, new_film)
        database.commit()

        show_films(cursor, "DISPLAYING FILMS AFTER INSERT")

        # Update Alien from SciFi to Horror.

        cursor.execute(UPDATE_FILM_GENRE_QUERY, ("Horror", "Alien"))
        database.commit()

        show_films(cursor, "DISPLAYING FILMS AFTER UPDATE")

        # Delete Gladiator.

        cursor.execute(DELETE_FILM_QUERY, ("Gladiator",))
        database.commit()

        show_films(cursor, "DISPLAYING FILMS AFTER DELETE")

    except mysql.connector.Error as err:
        print(f"Error while executing database operation: {err}")

        if database is not None:
            database.rollback()
            print("Database changes were rolled back.")

    finally:
        if cursor is not None:
            cursor.close()

        disconnect_database(database)


if __name__ == "__main__":
    main()