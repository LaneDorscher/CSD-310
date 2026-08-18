from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class PurchaseOrderDetailRepository(BaseEntityRepository):
    table_name = "PURCHASE_ORDER_DETAIL"
    primary_key = "PURCHASE_ORDER_DETAIL_ID"
