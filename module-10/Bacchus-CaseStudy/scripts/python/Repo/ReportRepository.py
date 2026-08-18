from scripts.python.SqlLoader import SqlLoader


class ReportRepository:

    def __init__(self, connection):
        self.connection = connection

    def get_supplier_delivery_performance_report(self):
        query = SqlLoader.load("reports/supplier_delivery_performance_report.sql")
        cursor = self.connection.cursor(dictionary=True)
        cursor.execute(query)
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def get_supplier_delivery_percentage_report(self):
        query = SqlLoader.load("reports/supplier_delivery_rate_report.sql")
        cursor = self.connection.cursor(dictionary=True)
        cursor.execute(query)
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def get_distributor_product_sales_report(self):
        query = SqlLoader.load("reports/distributor_sales_report.sql")
        cursor = self.connection.cursor(dictionary=True)
        cursor.execute(query)
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def get_distributor_product_report(self):
        query = SqlLoader.load("reports/distributor_product_report.sql")
        cursor = self.connection.cursor(dictionary=True)
        cursor.execute(query)
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def get_employee_quarterly_hours_report(self):
        query = SqlLoader.load("reports/employee_quarterly_hours_report.sql")
        cursor = self.connection.cursor(dictionary=True)
        cursor.execute(query)
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def get_supply_inventory(self):
        query = SqlLoader.load("reports/supply_inventory.sql")
        cursor = self.connection.cursor(dictionary=True)
        cursor.execute(query)
        rows = cursor.fetchall()
        cursor.close()
        return rows