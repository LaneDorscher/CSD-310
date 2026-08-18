'''
Author: Group A
        Lane Dorscher
        Chelsea Mcelhiney
        Pedro Avila
Date: 8/8/2026
Course: CSD-310
Assignment: Module 9.1 Milestone #2
Description: Base Repository class to pull from single table. Provides means to get all records from a table and print
             out as a dictionary object OR formatted table
'''


class BaseEntityRepository:

    table_name = None
    primary_key = None

    entity_columns = None


    def __init__(self, connection):
        self.connection = connection
        self.entity_columns = self.get_columns()

    def get_all(self):
        cursor = self.connection.cursor(dictionary=True)
        query = f"SELECT * FROM {self.table_name}"
        cursor.execute(query)

        records = cursor.fetchall()
        cursor.close()

        return records

    def get_columns(self):
        """Return the columns present in the table."""
        if self.table_name is None:
            return None

        cursor = self.connection.cursor()
        cursor.execute(f"SELECT * FROM {self.table_name} LIMIT 0")
        cursor.fetchall()
        columns = [column[0] for column in cursor.description]
        cursor.close()
        return columns

    def get_by_id(self, record_id):
        cursor = self.connection.cursor(dictionary=True)
        query = f"SELECT * FROM {self.table_name} WHERE {str(self.primary_key)} = %s"
        cursor.execute(query, (record_id,))
        record = cursor.fetchone()
        cursor.close()
        return record


