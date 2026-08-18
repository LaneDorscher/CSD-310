from scripts.python.Repo.BaseEntityRepository import BaseEntityRepository
class TimeEntryRepository(BaseEntityRepository):
    table_name = "TIME_ENTRY"
    primary_key = "TIME_ENTRY_ID"


