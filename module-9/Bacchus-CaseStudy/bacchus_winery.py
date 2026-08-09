'''
Author: Group A
        Lane Dorscher
        Chelsea Mcelhiney
        Pedro Avila
Date: 8/8/2026
Course: CSD-310
Assignment: Module 9.1 Milestone #2
Description: This program connects to the bacchus_winery database and prints out all the tables.
'''

import sys
from dotenv import dotenv_values

from scripts.python.Database import Database
from scripts.python.Repo import *

database_config = None

def main():
    ## Load database settings from the .env file.
    secrets = dotenv_values(".env")
    global database_config
    try:
        database_config = {
            "user": secrets["USER"],
            "password": secrets["PASSWORD"],
            "host": secrets["HOST"],
            "port": int(secrets["PORT"]),
            "database": secrets["DATABASE"],
            "raise_on_warnings":
                secrets.get("RAISE_ON_WARNINGS", "true").lower() == "true"
        }
    except KeyError:
        print("Error connecting to MySQL database. Please check your env variables.")
        sys.exit()

    database = Database(database_config)
    repositories = [
        SupplierRepository(database.connection),
        SupplierItemRepository(database.connection),
        ItemRepository(database.connection),
        PurchaseOrderRepository(database.connection),
        PurchaseOrderDetailRepository(database.connection),
        PurchaseOrderDeliveryRepository(database.connection),
        DistributorRepository(database.connection),
        DistributorItemRepository(database.connection),
        SalesOrderRepository(database.connection),
        SalesOrderDetailRepository(database.connection),
        SalesOrderShipmentRepository(database.connection),
        EmployeeRepository(database.connection),
        TimeEntryRepository(database.connection)
    ]

    for repository in repositories:
        print()
        repository.print_all_formatted()

    database.close()
    sys.exit(0)


if __name__ == '__main__':
    main()
