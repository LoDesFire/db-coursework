import pymysql.cursors
import pymysql


class DatabaseConnection:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DatabaseConnection, cls).__new__(cls)
            cls._instance.connection = None
        return cls._instance

    def __enter__(self):
        if self.connection is None:
            self.connection = pymysql.connect(
                autocommit=True,
                host='localhost',
                user='root',
                password='root',
                database='study',
                cursorclass=pymysql.cursors.DictCursor
            )
        return self.connection

    def __exit__(self, exc_type, exc_value, traceback):
        if self.connection is not None:
            self.connection.close()
            self.connection = None

