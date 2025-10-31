from src.database import DatabaseConnection
from src.database.exception_handler_decorator import db_exception_handler


class RoleRepository:

    @staticmethod
    @db_exception_handler
    def get_roles():
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                "SELECT * FROM roles",
            )
            role = cursor.fetchall()
        return role

    @staticmethod
    @db_exception_handler
    def get_role(role_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                "SELECT * FROM roles WHERE id = %s",
                (role_id,)
            )
            role = cursor.fetchone()
        return role

    @staticmethod
    @db_exception_handler
    def create_role(name, payment_refund_right=False, manage_routes_right=False, manage_roles_right=False,
                    manage_employees_right=False):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                """
                INSERT INTO roles (name, payment_refund_right, manage_routes_right, manage_roles_right, manage_employees_right)
                VALUES (%s, %s, %s, %s, %s)
                """,
                (name, payment_refund_right, manage_routes_right, manage_roles_right, manage_employees_right)
            )
            role_id = cursor.lastrowid
        cxn.commit()
        return role_id

    @staticmethod
    @db_exception_handler
    def update_role(role_id, name=None, payment_refund_right=None, manage_routes_right=None, manage_roles_right=None,
                    manage_employees_right=None):
        cxn = DatabaseConnection().connection
        updates = []
        params = []

        if name is not None:
            updates.append("name = %s")
            params.append(name)
        if payment_refund_right is not None:
            updates.append("payment_refund_right = %s")
            params.append(payment_refund_right)
        if manage_routes_right is not None:
            updates.append("manage_routes_right = %s")
            params.append(manage_routes_right)
        if manage_roles_right is not None:
            updates.append("manage_roles_right = %s")
            params.append(manage_roles_right)
        if manage_employees_right is not None:
            updates.append("manage_employees_right = %s")
            params.append(manage_employees_right)

        if updates:
            params.append(role_id)
            query = f"UPDATE roles SET {', '.join(updates)} WHERE id = %s"
            with cxn.cursor() as cursor:
                cursor.execute(query, tuple(params))
        cxn.commit()

    @staticmethod
    @db_exception_handler
    def delete_role(role_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                "DELETE FROM roles WHERE id = %s",
                (role_id,)
            )
        cxn.commit()
