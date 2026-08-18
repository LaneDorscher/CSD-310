'''
Author: Group A
        Lane Dorscher
        Chelsea Mcelhiney
        Pedro Avila
Date: 8/14/2026
Course: CSD-310
Assignment: Module 9.1 Milestone #2
Description: This class loads sql files from the scripts/sql directory. Keep 1 query per file
'''
from pathlib import Path

class SqlLoader:
    """Loads SQL statements from .sql files."""

    BASE_PATH = (
        Path(__file__).resolve().parents[1]
        / "sql"
    )

    __SQL_CACHE = {}

    @classmethod
    def load(cls, relative_path):
        sql_path = cls.BASE_PATH / relative_path
        ## does path exist?
        if not sql_path.exists():
            return None

        ## did we previously cache the sql string?
        if relative_path in cls.__SQL_CACHE:
            return cls.__SQL_CACHE[relative_path]

        ## fet the sql string and cache it
        with open(sql_path, "r", encoding="utf-8") as file:
            cls.__SQL_CACHE[relative_path] = file.read()
        return cls.__SQL_CACHE[relative_path]