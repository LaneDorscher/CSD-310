from scripts.python.Repo.BaseRepository import BaseRepository


class SupplierItemRepository(BaseRepository):
    table_name = "SUPPLIER_ITEM"
    primary_key = ("SUPPLIER_ID", "ITEM_ID")
