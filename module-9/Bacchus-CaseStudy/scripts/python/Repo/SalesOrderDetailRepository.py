from scripts.python.Repo.BaseRepository import BaseRepository


class SalesOrderDetailRepository(BaseRepository):
    table_name = "SALES_ORDER_DETAIL"
    primary_key = "SALES_ORDER_DETAIL_ID"
