from scripts.python.Repo.BaseRepository import BaseRepository


class DistributorItemRepository(BaseRepository):
    table_name = "DISTRIBUTOR_ITEM"
    primary_key = ("DISTRIBUTOR_ID", "ITEM_ID")
