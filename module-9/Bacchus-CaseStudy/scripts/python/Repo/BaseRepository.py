


class BaseRepository:

    table_name = None
    primary_key = None

    def __init__(self, connection):
        self.connection = connection


    def get_all(self):
        cursor = self.connection.cursor(dictionary=True)
        query = f"SELECT * FROM {self.table_name}"
        cursor.execute(query)

        records = cursor.fetchall()
        cursor.close()

        return records

    def print_all(self):
        '''Print all records as a dictionary object'''
        records = self.get_all()
        print(f"---- {self.table_name} ({str(len(records))} records) ----")

        if not records:
            print("No records found.")
            return

        for record in records:
            print(record)

    def print_all_formatted(self):
        """Print all records in an evenly spaced table format."""
        cursor = self.connection.cursor()
        cursor.execute(f"SELECT * FROM {self.table_name}")

        rows = cursor.fetchall()
        columns = [column[0] for column in cursor.description]

        # Print table name
        print(f"---- {self.table_name} ({str(len(rows))} records) ----")

        if not rows:
            print("No records found.")
            cursor.close()
            return

        # Determine the required width for each column.
        widths = []

        for index, column in enumerate(columns):
            data_width = max(
                len(str(row[index])) if row[index] is not None else 4
                for row in rows
            )

            widths.append(max(len(column), data_width))

        # Print column headers.
        header = "    ".join(
            f"{column:<{widths[index]}}"
            for index, column in enumerate(columns)
        )

        print(header)

        # Print records.
        for row in rows:
            formatted_row = "    ".join(
                f"{str(value) if value is not None else 'NULL':<{widths[index]}}"
                for index, value in enumerate(row)
            )

            print(formatted_row)

        cursor.close()

    def get_by_id(self, record_id):
        cursor = self.connection.cursor(dictionary=True)
        query = f"SELECT * FROM {self.table_name} WHERE {str(self.primary_key)} = %s"
        cursor.execute(query, (record_id,))
        record = cursor.fetchone()
        cursor.close()
        return record


