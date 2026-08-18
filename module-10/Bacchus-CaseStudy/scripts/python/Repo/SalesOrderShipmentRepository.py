from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class SalesOrderShipmentRepository(BaseEntityRepository):
    table_name = "SALES_ORDER_SHIPMENT"
    primary_key = "SALES_ORDER_SHIPMENT_ID"
