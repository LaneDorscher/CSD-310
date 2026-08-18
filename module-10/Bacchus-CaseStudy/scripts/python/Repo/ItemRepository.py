from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class ItemRepository(BaseEntityRepository):
    table_name = "ITEM"
    primary_key = "ITEM_ID"
