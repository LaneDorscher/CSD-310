from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository
class SalesOrderRepository(BaseEntityRepository):
    table_name = "SALES_ORDER"
    primary_key = "SALES_ORDER_ID"

