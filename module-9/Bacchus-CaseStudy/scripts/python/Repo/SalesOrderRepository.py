from scripts.python.Repo.BaseRepository import BaseRepository
class SalesOrderRepository(BaseRepository):
    table_name = "SALES_ORDER"
    primary_key = "SALES_ORDER_ID"

