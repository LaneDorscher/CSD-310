from scripts.python.Repo.BaseRepository import BaseRepository


class EmployeeRepository(BaseRepository):
    table_name = "EMPLOYEE"
    primary_key = "EMPLOYEE_ID"
