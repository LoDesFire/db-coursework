from src.database import DatabaseConnection
from src.database.exception_handler_decorator import db_exception_handler


class EmployeeRepository:

    @staticmethod
    @db_exception_handler
    def get_employees():
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                """
                SELECT e.* FROM employees e
                """,
            )
            employees = cursor.fetchall()
        return employees

    @staticmethod
    @db_exception_handler
    def get_employee_with_role(employee_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                """
                SELECT e.*, r.name AS role_name, r.payment_refund_right, r.manage_routes_right, 
                       r.manage_roles_right, r.manage_employees_right
                FROM employees e
                LEFT JOIN roles r ON e.role_id = r.id
                WHERE e.id = %s
                """,
                (employee_id,)
            )
            employee = cursor.fetchone()
        return employee

    @staticmethod
    @db_exception_handler
    def create_employee(email, position, first_name, last_name, role_name, middle_name=None, address=None, phone_number=None):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute("SELECT id FROM users WHERE email = %s", (email,))
            user = cursor.fetchone()
            if not user:
                return None
            user_id = user.get("id", None)
            cursor.execute("SELECT r.id FROM roles r WHERE r.name = %s", (role_name,))
            role = cursor.fetchone()
            if not role:
                return None
            role_id = role.get("id", None)
            cursor.execute(
                """
                INSERT INTO employees (user_id, position, first_name, last_name, middle_name, address, phone_number, role_id)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                """,
                (user_id, position, first_name, last_name, middle_name, address, phone_number, role_id)
            )
            employee_id = cursor.lastrowid
        cxn.commit()
        return employee_id

    @staticmethod
    @db_exception_handler
    def update_employee(email, position=None, first_name=None, last_name=None, middle_name=None, address=None,
                        phone_number=None, role_name=None):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute("SELECT id FROM users WHERE email = %s", (email,))
            user = cursor.fetchone()
            if not user:
                print("Пользователь с таким email не найден.")
                return

            cursor.execute("SELECT r.id FROM roles r WHERE r.name = %s", (role_name,))
            role = cursor.fetchone()
            if not role:
                role_id = None
            else:
                role_id = role.get("id", None)
            employee_id = user['id']

            updates = []
            params = []

            if position:
                updates.append("position = %s")
                params.append(position)
            if first_name:
                updates.append("first_name = %s")
                params.append(first_name)
            if last_name:
                updates.append("last_name = %s")
                params.append(last_name)
            if middle_name:
                updates.append("middle_name = %s")
                params.append(middle_name)
            if address:
                updates.append("address = %s")
                params.append(address)
            if phone_number:
                updates.append("phone_number = %s")
                params.append(phone_number)
            if role_id:
                updates.append("role_id = %s")
                params.append(role_id)

            if updates:
                params.append(employee_id)
                query = f"UPDATE employees SET {', '.join(updates)} WHERE user_id = %s"
                cursor.execute(query, tuple(params))
        cxn.commit()
        return employee_id

    @staticmethod
    @db_exception_handler
    def delete_employee(email):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute("SELECT id FROM users WHERE email = %s", (email,))
            user = cursor.fetchone()
            if not user:
                print("Пользователь с таким email не найден.")
                return
            employee_id = user['id']
            cursor.execute("DELETE FROM employees WHERE user_id = %s", (employee_id,))
        cxn.commit()
        return employee_id
