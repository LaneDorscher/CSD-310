from scripts.python.Repo import ReportRepository, BaseEntityRepository


class BaseService:
    def __init__(self, repositories):
        if not isinstance(repositories, list):
            repositories = [repositories]

        self.repositories = repositories

    def print_records(self, rows):
        for row in rows:
            print(row)

    def print_records_formatted(self, rows, columns=None, title=None):
        if not rows:
            print("No records found.")
            return

        if columns is None:
            columns = list(rows[0].keys())

        # Determine width of each column.
        widths = []

        for column in columns:
            data_width = max(
                len(str(row[column]))
                if row[column] is not None
                else 4
                for row in rows
            )

            widths.append(
                max(len(column), data_width)
            )

        # Calculate total table width.
        # 4 spaces are used between each column.

        # Print title centered across the table.
        if title:
            table_width = max(sum(widths) + (4 * (len(columns) - 1)), len(title))

            print("-" * table_width)
            print(title.center(table_width))
            print("-" * table_width)

        # Print headers.
        header = "    ".join(
            f"{column:<{widths[index]}}"
            for index, column in enumerate(columns)
        )

        print(header)

        # Print records.
        for row in rows:
            formatted_row = "    ".join(
                f"{str(row[column]) if row[column] is not None else 'NULL':<{widths[index]}}"
                for index, column in enumerate(columns)
            )

            print(formatted_row)


class TableService(BaseService):

    def print_all_entities(self):
        """Print all entities in the database."""

        for repo in self.repositories:
            self.print_entity(repo)
            print()

    def print_entity(self, repo):
        """Print all records for an entity repository."""
        if not isinstance(repo, BaseEntityRepository):
            return
        rows = repo.get_all()

        self.print_records_formatted(rows, title=repo.table_name)

class ReportService(BaseService):

    def __init__(self, report_repo: ReportRepository):
        super().__init__(report_repo)
        self.report_repo = report_repo

    def print_monthly_delivery_performance(self):
        rows = self.report_repo.get_supplier_delivery_performance_report()
        self.print_records_formatted(rows,title="Monthly Delivery Performance")

    def print_supplier_delivery_rate_report(self):
        rows = self.report_repo.get_supplier_delivery_percentage_report()
        self.print_records_formatted(rows,title="Supplier Delivery Rate Report")

    def print_distributor_product_sales_report(self):
        rows = self.report_repo.get_distributor_product_sales_report()
        self.print_records_formatted(rows,title="Wine Sales Report")

    def print_distributor_products_report(self):
        rows = self.report_repo.get_distributor_product_report()
        self.print_records_formatted(rows,title="Distributor Products Report")

    def print_employee_hours_report(self):
        rows = self.report_repo.get_employee_quarterly_hours_report()
        self.print_records_formatted(rows,title="Employee Hours Report")

    def print_supply_inventory_report(self):
        rows = self.report_repo.get_supply_inventory()
        self.print_records_formatted(rows,title="Supply Inventory Report")
