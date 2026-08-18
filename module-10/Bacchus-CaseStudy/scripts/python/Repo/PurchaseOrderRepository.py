from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class PurchaseOrderRepository(BaseEntityRepository):
    table_name = "PURCHASE_ORDER"
    primary_key = "PURCHASE_ORDER_ID"

