from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class PurchaseOrderDeliveryRepository(BaseEntityRepository):
    table_name = "PURCHASE_ORDER_DELIVERY"
    primary_key = "PURCHASE_ORDER_DELIVERY_ID"
