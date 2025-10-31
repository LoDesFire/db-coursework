from src.database.repositories.employee_repository import EmployeeRepository


class EmployeeManagement:

    def __init__(self, employee_id):
        self.employee_id = employee_id

    def check_manage_employees_right(self):
        employee_info = EmployeeRepository.get_employee_with_role(self.employee_id)
        if not employee_info['manage_employees_right']:
            print("У вас нет прав на управление сотрудниками.")
            return False
        return True

    def add_employee(self):
        if not self.check_manage_employees_right():
            return

        email = input("Введите Email пользователя: ")
        first_name = input("Введите имя: ")
        last_name = input("Введите фамилию: ")
        middle_name = input("Введите отчество (если есть): ")
        position = input("Введите должность: ")
        phone_number = input("Введите номер телефона (возможен пропуск): ")
        address = input("Введите адрес (возможен пропуск): ")
        role_name = input("Введите название роли: ")

        employee_id = EmployeeRepository.create_employee(
            email=email,
            first_name=first_name,
            last_name=last_name,
            middle_name=middle_name,
            position=position,
            role_name=role_name,
            phone_number=phone_number,
            address=address
        )
        if employee_id:
            print(f"Сотрудник добавлен")
        else:
            print("Ошибка добавления сотрудника")

    def delete_employee(self):
        if not self.check_manage_employees_right():
            return

        email = input("Введите Email сотрудника для удаления: ")
        if EmployeeRepository.delete_employee(email):
            print(f"Сотрудник с Email {email} удален")

    def update_employee(self):
        if not self.check_manage_employees_right():
            return

        email = input("Введите Email сотрудника для обновления: ")
        first_name = input("Введите новое имя (оставьте пустым для пропуска): ")
        last_name = input("Введите новую фамилию (оставьте пустым для пропуска): ")
        middle_name = input("Введите новое отчество (оставьте пустым для пропуска): ")
        position = input("Введите новую должность (оставьте пустым для пропуска): ")
        phone_number = input("Введите номер телефона (оставьте пустым для пропуска): ")
        address = input("Введите адрес (оставьте пустым для пропуска): ")
        role_name = input("Введите название роли (оставьте пустым для пропуска): ")

        if EmployeeRepository.update_employee(
                email=email,
                first_name=first_name,
                last_name=last_name,
                middle_name=middle_name,
                position=position,
                role_name=role_name,
                phone_number=phone_number,
                address=address
        ):
            print(f"Информация о сотруднике с Email {email} обновлена")

    def list_employees(self):
        if not self.check_manage_employees_right():
            return

        employees = EmployeeRepository.get_employees()
        if not employees:
            print("Нет сотрудников")
            return

        print("Список всех сотрудников:")
        for employee in employees:
            print(
                f" - {employee['last_name']} {employee['first_name']} {employee['middle_name']} ({employee['position']})"
            )
        print("\n")
