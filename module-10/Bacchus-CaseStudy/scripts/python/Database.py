'''
Author: Lane Dorscher (Group A)
File: Database.py
Description: This class creates an abstraction to connect to the mysql database

'''
import sys

import mysql.connector
from mysql.connector import errorcode


class Database:
    def __init__(self, config):
        try:
            self.connection = mysql.connector.connect(**config)

            print(
                f"\nDatabase user {config['user']} connected to "
                f"MySQL on host {config['host']} with database "
                f"{config['database']}."
            )

        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
                print("The supplied username or password is invalid.")

            elif err.errno == errorcode.ER_BAD_DB_ERROR:
                print("The specified database does not exist.")

            else:
                print(f"Database connection error: {err}")
            sys.exit(1)

    def close(self):
        if self.connection.is_connected():
            self.connection.close()
            print("Database connection closed.")