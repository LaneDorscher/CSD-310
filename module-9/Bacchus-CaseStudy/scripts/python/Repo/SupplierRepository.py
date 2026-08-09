from scripts.python.Repo.BaseRepository import BaseRepository


class SupplierRepository(BaseRepository):
    table_name = "SUPPLIER"
    primary_key = "SUPPLIER_ID"

