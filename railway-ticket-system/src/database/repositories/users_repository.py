from src.database import DatabaseConnection
from typing import Optional, Dict
from src.database.exception_handler_decorator import db_exception_handler


class UserRepository:

    @staticmethod
    @db_exception_handler
    def authenticate_user(login: str, password: str):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            query = "CALL AuthenticateUser(%s, %s)"
            cursor.execute(query, (login, password))
            user_ids = cursor.fetchone()
            return user_ids

    @staticmethod
    @db_exception_handler
    def get_user(user_id: str):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            query = "SELECT email, login, register_datetime FROM users WHERE id = %s"
            cursor.execute(query, (user_id,))
            user = cursor.fetchone()
            return user

    @staticmethod
    @db_exception_handler
    def update_user(user_id: str, email: str = None, login: str = None, password: str = None):
        cxn = DatabaseConnection().connection
        updates = []
        params = []

        if email:
            updates.append("email = %s")
            params.append(email)
        if login:
            updates.append("login = %s")
            params.append(login)
        if password:
            updates.append("password_hash = %s")
            params.append(password)

        if not updates:
            return None

        params.append(user_id)
        query = f"UPDATE users SET {', '.join(updates)} WHERE id = %s"

        with cxn.cursor() as cursor:
            cursor.execute(query, tuple(params))
            user = cursor.fetchone()

        cxn.commit()
        return user

    @staticmethod
    @db_exception_handler
    def register_user(login: str, email: str, password: str):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            query = "CALL CreateUser(%s, %s, %s)"
            cursor.execute(query, (login, email, password))
            user_id = cursor.fetchone()

        cxn.commit()
        return user_id

    @staticmethod
    @db_exception_handler
    def get_user_role(user_id: int) -> Optional[Dict]:
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            query = """
                    SELECT roles.id AS role_id, roles.name AS role_name, roles.payment_refund_right,
                           roles.manage_routes_right, roles.manage_roles_right, roles.manage_employees_right
                    FROM employees
                    JOIN roles ON employees.role_id = roles.id
                    WHERE employees.user_id = %s
                """
            cursor.execute(query, (user_id,))
            role = cursor.fetchone()
            return role
