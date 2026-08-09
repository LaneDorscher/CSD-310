from scripts.python.Repo.BaseRepository import BaseRepository


class ItemRepository(BaseRepository):
    table_name = "ITEM"
    primary_key = "ITEM_ID"
