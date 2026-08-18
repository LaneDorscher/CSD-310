from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class DistributorItemRepository(BaseEntityRepository):
    table_name = "DISTRIBUTOR_ITEM"
    primary_key = ("DISTRIBUTOR_ID", "ITEM_ID")
