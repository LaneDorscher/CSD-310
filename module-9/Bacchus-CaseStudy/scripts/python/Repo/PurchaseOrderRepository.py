from scripts.python.Repo.BaseRepository import BaseRepository


class PurchaseOrderRepository(BaseRepository):
    table_name = "PURCHASE_ORDER"
    primary_key = "PURCHASE_ORDER_ID"

