from scripts.python.Repo.BaseRepository import BaseRepository


class PurchaseOrderDetailRepository(BaseRepository):
    table_name = "PURCHASE_ORDER_DETAIL"
    primary_key = "PURCHASE_ORDER_DETAIL_ID"
