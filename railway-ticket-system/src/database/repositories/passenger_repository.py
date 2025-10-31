from src.database import DatabaseConnection
from src.database.exception_handler_decorator import db_exception_handler


class PassengerRepository:

    @staticmethod
    @db_exception_handler
    def create_passenger(user_id, first_name, last_name, middle_name=None, phone_number=None, passport=None):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            passport_id = None
            if passport:
                cursor.execute(
                    "INSERT INTO passports (serial_number, issue_date, expiration_date, country, issue_place) VALUES (%s, %s, %s, %s, %s)",
                    (
                        passport['serial_number'],
                        passport['issue_date'],
                        passport['expiration_date'],
                        passport['country'],
                        passport['issue_place']
                    )
                )
                passport_id = cursor.lastrowid

            cursor.execute(
                "INSERT INTO passengers (user_id, first_name, last_name, middle_name, phone_number, passport_id) VALUES (%s, %s, %s, %s, %s, %s)",
                (user_id, first_name, last_name, middle_name, phone_number, passport_id)
            )
            passenger_id = cursor.lastrowid

        cxn.commit()
        return passenger_id

    @staticmethod
    @db_exception_handler
    def read_passengers(user_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                """
            SELECT p.id, p.first_name, p.last_name, p.middle_name, p.phone_number, pa.serial_number, pa.country, pa.issue_place, pa.expiration_date, pa.issue_date
            FROM passengers p 
            LEFT JOIN passports pa ON p.passport_id = pa.id 
            WHERE p.user_id = %s
            """,
                (user_id,)
            )
            passengers = cursor.fetchall()
        return passengers

    @staticmethod
    @db_exception_handler
    def update_passenger(passenger_id, first_name=None, last_name=None, middle_name=None, phone_number=None,
                         passport=None):
        cxn = DatabaseConnection().connection
        updates = []
        params = []

        if first_name:
            updates.append("first_name = %s")
            params.append(first_name)
        if last_name:
            updates.append("last_name = %s")
            params.append(last_name)
        if middle_name:
            updates.append("middle_name = %s")
            params.append(middle_name)
        if phone_number:
            updates.append("phone_number = %s")
            params.append(phone_number)

        if updates:
            params.append(passenger_id)
            query = f"UPDATE passengers SET {', '.join(updates)} WHERE id = %s"
            with cxn.cursor() as cursor:
                cursor.execute(query, tuple(params))

        if passport:
            passport_updates = []
            passport_params = []
            for field in ['serial_number', 'issue_date', 'expiration_date', 'country', 'issue_place']:
                if field in passport:
                    passport_updates.append(f"{field} = %s")
                    passport_params.append(passport[field])

            if passport_updates:
                cursor.execute("SELECT passport_id FROM passengers WHERE id = %s", (passenger_id,))
                passport_id = cursor.fetchone()['passport_id']
                if passport_id:
                    passport_params.append(passport_id)
                    query = f"UPDATE passports SET {', '.join(passport_updates)} WHERE id = %s"
                    with cxn.cursor() as cursor:
                        cursor.execute(query, tuple(passport_params))

        cxn.commit()

    @staticmethod
    @db_exception_handler
    def delete_passenger(passenger_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                "DELETE FROM passengers WHERE id = %s",
                (passenger_id,)
            )
        cxn.commit()
