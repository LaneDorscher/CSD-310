from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository


class EmployeeRepository(BaseEntityRepository):
    table_name = "EMPLOYEE"
    primary_key = "EMPLOYEE_ID"
