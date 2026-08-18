from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class SupplierItemRepository(BaseEntityRepository):
    table_name = "SUPPLIER_ITEM"
    primary_key = ("SUPPLIER_ID", "ITEM_ID")
