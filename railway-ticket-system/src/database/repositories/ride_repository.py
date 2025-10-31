from src.database import DatabaseConnection
from src.database.exception_handler_decorator import db_exception_handler


class RideRepository:
    @staticmethod
    @db_exception_handler
    def cancel_ride(ride_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                "UPDATE rides SET status = %s WHERE id = %s",
                ("CANCELED", ride_id)
            )
        cxn.commit()
        return True
