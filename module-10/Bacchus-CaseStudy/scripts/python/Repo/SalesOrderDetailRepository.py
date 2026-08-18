from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class SalesOrderDetailRepository(BaseEntityRepository):
    table_name = "SALES_ORDER_DETAIL"
    primary_key = "SALES_ORDER_DETAIL_ID"
