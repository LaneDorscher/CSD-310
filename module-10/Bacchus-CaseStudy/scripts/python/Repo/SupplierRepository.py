from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class SupplierRepository(BaseEntityRepository):
    table_name = "SUPPLIER"
    primary_key = "SUPPLIER_ID"

