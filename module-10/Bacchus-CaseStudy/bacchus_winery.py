'''
Author: Group A
        Lane Dorscher
        Chelsea Mcelhiney
        Pedro Avila
Date: 8/13 /2026
Course: CSD-310
Assignment: Module 9.1 Milestone #2
Description: This program connects to the bacchus_winery database and prints out all the tables.
'''

import sys
from dotenv import dotenv_values

from scripts.python.Database import Database
from scripts.python.Repo import *
from scripts.python.Service.ReportService import TableService, ReportService

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
    sup_repo = SupplierRepository(database.connection)
    sup_item_repo = SupplierItemRepository(database.connection)
    item_repo = ItemRepository(database.connection)
    pur_repo = PurchaseOrderRepository(database.connection)
    pur_order_detail_repo = PurchaseOrderDetailRepository(database.connection)
    pur_order_delivery_repo = PurchaseOrderDeliveryRepository(database.connection)
    dist_repo = DistributorRepository(database.connection)
    dist_item_repo = DistributorItemRepository(database.connection)
    sal_repo = SalesOrderRepository(database.connection)
    sal_order_detail_repo = SalesOrderDetailRepository(database.connection)
    sal_order_shipment_repo = SalesOrderShipmentRepository(database.connection)
    emp_repo = EmployeeRepository(database.connection)
    time_entry_repo = TimeEntryRepository(database.connection)
    supplier_report_repo = ReportRepository(database.connection)

    repositories = [sup_repo,sup_item_repo,item_repo,pur_repo,pur_order_detail_repo,pur_order_delivery_repo,dist_repo,
                    dist_item_repo, sal_repo,sal_order_detail_repo,sal_order_shipment_repo,emp_repo,time_entry_repo,
                    supplier_report_repo]

    table_service = TableService(repositories)
    report_service = ReportService(supplier_report_repo)

    services = [table_service, report_service]

    # main loop
    while True:
        print_menu()
        option = get_menu_option()
        if option is None:
            continue
        if option == "1":
            table_service.print_all_entities()
        elif option == "2":
            report_service.print_monthly_delivery_performance()
            report_service.print_supplier_delivery_rate_report()
        elif option == "3":
            report_service.print_distributor_products_report()
            report_service.print_distributor_product_sales_report()
        elif option == "4":
           report_service.print_employee_hours_report()
        elif option == "5":
            report_service.print_supply_inventory_report()
        elif option == "Q":
            break
        else:
            print("Invalid option. Please select from the menu.")

    print_goodbye()
    database.close()
    sys.exit(0)

def print_menu():
    print(
        "\nBacchus Winery Report Menu:\n"
        " 1 - Full Table Print\n"
        " 2 - Supplier Delivery Performance Report\n"
        " 3 - Wine Distribution and Sales Report\n"
        " 4 - Employee Quarterly Hours Report\n"
        " 5 - Supply Inventory Report\n"
        " Q - Quit"
    )

def get_menu_option():
    available_options = ["1", "2", "3", "4", "5", "Q"]
    option = input("Enter Menu Option: ").strip().upper()
    print()
    if option in available_options:
        return option
    print("\nInvalid Menu Option. Try again from the menu!\n")
    return None

def print_goodbye():
    print("Bacchus Winery Report Goodbye!\n")

if __name__ == '__main__':
    main()
