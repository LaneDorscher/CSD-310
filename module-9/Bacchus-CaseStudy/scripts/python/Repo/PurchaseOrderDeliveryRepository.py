from scripts.python.Repo.BaseRepository import BaseRepository


class PurchaseOrderDeliveryRepository(BaseRepository):
    table_name = "PURCHASE_ORDER_DELIVERY"
    primary_key = "PURCHASE_ORDER_DELIVERY_ID"
