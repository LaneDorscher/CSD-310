## Author: Lane Dorscher
## Date:  07/14/2026
## Course: CSD-310
## Assignment: 6.2
## Description: This programs reads from the movies database and prints out the records to the console.

import sys

import mysql.connector
from mysql.connector import errorcode
from dotenv import dotenv_values


# Load database settings from the .env file.
secrets = dotenv_values(".env")

DATABASE_CONFIG = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "port": int(secrets["PORT"]),
    "database": secrets["DATABASE"],
    "raise_on_warnings": secrets.get("RAISE_ON_WARNINGS", "true").lower() == "true"
}

# MySQL Queries

FIND_ALL_STUDIOS = """
    SELECT studio_id, studio_name
    FROM studio
"""

FIND_ALL_GENRES = """
    SELECT genre_id, genre_name
    FROM genre
"""

FIND_SHORT_FILMS = """
    SELECT film_name, film_runtime
    FROM film
    WHERE film_runtime <= %s
    ORDER BY film_runtime
"""

FIND_FILMS_AND_DIRECTORS = """
    SELECT film_director, film_name
    FROM film
    ORDER BY film_director, film_releaseDate ASC
"""

# Functions

def main():
    """Application entry point"""

    database = None
    cursor = None

    try:
        database = connect_database()
        cursor = database.cursor()

        display_studios(cursor)
        display_genres(cursor)
        display_short_films(cursor, runtime_hours=2)
        display_films_and_directors(cursor)

    except mysql.connector.Error as err:
        print(f"Error while executing database operation: {err}")

    finally:
        if cursor is not None:
            cursor.close()

        disconnect_database(database)


def display_studios(cursor):
    """Display studio records from database, requires cursor"""
    cursor.execute(FIND_ALL_STUDIOS)
    studios = cursor.fetchall()

    print("\n-- DISPLAYING studio RECORDS --")

    for studio_id, studio_name in studios:
        print(f"Studio ID: {studio_id}")
        print(f"Studio Name: {studio_name}")
        print()


def display_genres(cursor):
    """Display genre records from database, requires cursor"""

    cursor.execute(FIND_ALL_GENRES)
    genres = cursor.fetchall()

    print("\n-- DISPLAYING genre RECORDS --")

    for genre_id, genre_name in genres:
        print(f"Genre ID: {genre_id}")
        print(f"Genre Name: {genre_name}")
        print()


def display_short_films(cursor, runtime_hours):
    """Display short film records from database, requires cursor and runtime hours"""

    runtime_minutes = runtime_hours * 60

    cursor.execute(FIND_SHORT_FILMS, (runtime_minutes,))
    films = cursor.fetchall()

    print(
        f"\n-- DISPLAYING short film RECORDS --"
    )

    for film_name, film_runtime in films:
        print(f"Film Name: {film_name}")
        print(f"Runtime: {film_runtime} minutes")
        print()


def display_films_and_directors(cursor):
    """Display film records from database, requires cursor"""
    cursor.execute(FIND_FILMS_AND_DIRECTORS)
    films = cursor.fetchall()

    print("\n-- DISPLAYING Director RECORDS in Order --")

    for film_director, film_name in films:
        print(f"Film Name: {film_name}")
        print(f"Director: {film_director}")
        print()


def connect_database():
    """Connect to MySQL database using supplied credentials"""
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
    """Disconnect from MySQL database if able"""
    if database is not None and database.is_connected():
        database.close()
        print("\nDatabase connection closed.")


if __name__ == "__main__":
    main()