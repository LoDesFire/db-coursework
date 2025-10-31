from src.database.repositories.employee_repository import EmployeeRepository
from src.database.repositories.role_repository import RoleRepository


class Role:

    @staticmethod
    def add_role(employee_id):
        # Проверка прав на управление ролями
        employee_info = EmployeeRepository.get_employee_with_role(employee_id)
        if not employee_info['manage_roles_right']:
            print("У вас нет прав на управление ролями.")
            return

        name = input("Введите имя новой роли: ")
        payment_refund_right = input("Права на возврат платежей (true/false): ").strip().lower() == 'true'
        manage_routes_right = input("Права на управление маршрутами (true/false): ").strip().lower() == 'true'
        manage_roles_right = input("Права на управление ролями (true/false): ").strip().lower() == 'true'
        manage_employees_right = input("Права на управление сотрудниками (true/false): ").strip().lower() == 'true'

        RoleRepository.create_role(
            name=name,
            payment_refund_right=payment_refund_right,
            manage_routes_right=manage_routes_right,
            manage_roles_right=manage_roles_right,
            manage_employees_right=manage_employees_right
        )

        print("Роль успешно добавлена.")

    @staticmethod
    def get_roles(employee_id):
        # Проверка прав на управление ролями
        employee_info = EmployeeRepository.get_employee_with_role(employee_id)
        if not employee_info['manage_roles_right']:
            print("У вас нет прав на управление ролями.")
            return

        # Получение списка ролей
        roles = RoleRepository.get_roles()
        if not roles:
            print("Нет доступных ролей.")
            return

        # Вывод списка ролей с подробной информацией
        print("Список ролей:")
        for role in roles:
            print(f"Имя роли: {role['name']}")
            print(f"Права на возврат платежей: {'Да' if role['payment_refund_right'] else 'Нет'}")
            print(f"Права на управление маршрутами: {'Да' if role['manage_routes_right'] else 'Нет'}")
            print(f"Права на управление ролями: {'Да' if role['manage_roles_right'] else 'Нет'}")
            print(f"Права на управление сотрудниками: {'Да' if role['manage_employees_right'] else 'Нет'}")
            print("-" * 40)

    @staticmethod
    def update_role_interactive(employee_id):
        # Проверка прав на управление ролями
        employee_info = EmployeeRepository.get_employee_with_role(employee_id)
        if not employee_info['manage_roles_right']:
            print("У вас нет прав на управление ролями.")
            return

        roles = RoleRepository.get_roles()
        if not roles:
            print("Нет доступных ролей.")
            return

        print("Список ролей:")
        for idx, role in enumerate(roles, start=1):
            print(f"{idx}. {role['name']}")

        role_choice = int(input("Выберите номер роли для обновления: ")) - 1
        if role_choice < 0 or role_choice >= len(roles):
            print("Неправильный выбор.")
            return

        selected_role = roles[role_choice]
        role_id = selected_role['id']

        name = input(f"Введите новое имя роли (текущее: {selected_role['name']}): ") or selected_role['name']
        payment_refund_right = input(
            f"Права на возврат платежей (текущее: {selected_role['payment_refund_right']}): ").strip().lower() == 'true'
        manage_routes_right = input(
            f"Права на управление маршрутами (текущее: {selected_role['manage_routes_right']}): ").strip().lower() == 'true'
        manage_roles_right = input(
            f"Права на управление ролями (текущее: {selected_role['manage_roles_right']}): ").strip().lower() == 'true'
        manage_employees_right = input(
            f"Права на управление сотрудниками (текущее: {selected_role['manage_employees_right']}): ").strip().lower() == 'true'

        RoleRepository.update_role(
            role_id,
            name=name,
            payment_refund_right=payment_refund_right,
            manage_routes_right=manage_routes_right,
            manage_roles_right=manage_roles_right,
            manage_employees_right=manage_employees_right
        )

        print("Роль успешно обновлена.")
