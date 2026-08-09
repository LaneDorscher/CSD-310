from scripts.python.Repo.BaseRepository import BaseRepository


class SalesOrderShipmentRepository(BaseRepository):
    table_name = "SALES_ORDER_SHIPMENT"
    primary_key = "SALES_ORDER_SHIPMENT_ID"
