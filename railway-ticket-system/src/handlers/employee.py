from src.database import UserRepository
from src.database.repositories.ride_repository import RideRepository
from src.database.repositories.ticket_repository import TicketRepository
from src.handlers.employee_management import EmployeeManagement
from src.handlers.role import Role
from src.handlers.user import User
from src.database.repositories.employee_repository import EmployeeRepository


class Employee(User):

    def hello_message(self):
        print("Успешно авторизован как сотрудник!")

    def __init__(self, user_id, employee_id):
        super().__init__(user_id)
        self.employee_id = employee_id

    def run(self):
        while True:
            try:
                print("1. Просмотр профиля")
                print("2. Редактирование профиля")
                print("3. Кабинет сотрудника")
                print("0. Выход")
                choice = input("Выберите действие: ")
                if choice == "1":
                    self.view_profile()
                elif choice == "2":
                    self.edit_profile()
                elif choice == "3":
                    self.employee_dashboard()
                elif choice == "0":
                    break
                else:
                    print("Недопустимый выбор")
            except Exception as e:
                print(f"Произошла ошибка: {e}")

    def view_profile(self):
        employee_info = EmployeeRepository.get_employee_with_role(self.employee_id)
        user_info = UserRepository.get_user(self.user_id)
        print("Информация о сотруднике:")
        print(
            f"ФИО: {employee_info['last_name']} {employee_info['first_name']}{' ' + employee_info['middle_name'] if employee_info['middle_name'] is not None else ''}")
        print(f"Должность: {employee_info['position']}")
        print(f"Роль: {employee_info['role_name']}")
        print(f"Адрес: {employee_info['address']}, Номер телефона: {employee_info['phone_number']}")
        print(f"Права:\n"
              f"{'- Возврат платежей\n' if employee_info['payment_refund_right'] else ''}"
              f"{'- Управление маршрутами\n' if employee_info['manage_routes_right'] else ''}"
              f"{'- Управление ролями\n' if employee_info['manage_roles_right'] else ''}"
              f"{'- Управление сотрудниками\n' if employee_info['manage_employees_right'] else ''}"
              )
        print(f"Пользовательские данные: {user_info['login']} ({user_info['email']})")
        print(f"Дата регистрации: {user_info['register_datetime'].strftime('%Y-%m-%d %H:%M:%S')}\n\n")

    def employee_dashboard(self):
        employee_info = EmployeeRepository.get_employee_with_role(self.employee_id)
        if not employee_info:
            print("Информация о сотруднике не найдена.")
            return

        print("Кабинет сотрудника:")

        if employee_info['manage_routes_right']:
            print("\nУправление маршрутами:")
            print("1. Отмена маршрута")

        if employee_info['payment_refund_right']:
            print("\nВозврат билетов:")
            print("3. Возврат билета")

        if employee_info['manage_employees_right']:
            print("\nУправление сотрудниками:")
            print("4. Добавить сотрудника")
            print("5. Обновить сотрудника")
            print("6. Удалить сотрудника")
            print("7. Список всех сотрудников")

        if employee_info['manage_roles_right']:
            print("\nУправление ролями:")
            print("8. Добавить роль")
            print("9. Обновить роль")
            print("10. Просмотр всех ролей")

        choice = input("Выберите действие: ")
        employee_management = EmployeeManagement(self.employee_id)
        if choice == "1":
            self.cancel_ride()
        elif choice == "2":
            pass
            # self.update_route_interactive()
        elif choice == "3":
            pass
            self.refund_ticket()
        elif choice == "4":
            employee_management.add_employee()
        elif choice == "5":
            employee_management.update_employee()
        elif choice == "6":
            employee_management.delete_employee()
        elif choice == "7":
            employee_management.list_employees()
        elif choice == "8":
            Role.add_role(self.employee_id)
        elif choice == "9":
            Role.update_role_interactive(self.employee_id)
        elif choice == "10":
            Role.get_roles(self.employee_id)
        else:
            print("Недопустимый выбор")

    def refund_ticket(self):
        ticket_id = int(input("Введите ID тикета для возврата: "))
        if TicketRepository.refund_ticket(self.employee_id, ticket_id):
            print(f"Билет с ID {ticket_id} успешно возвращен")


    def cancel_ride(self):
        employee_info = EmployeeRepository.get_employee_with_role(self.employee_id)
        if not employee_info['manage_routes_right']:
            print("У вас нет прав на управление маршрутами.")
            return

        ride_id = input("Введите ID поездки для отмены: ")
        if RideRepository.cancel_ride(ride_id):
            print(f"Поездка с ID {ride_id} успешно отменена")
        else:
            print(f"Ошибка при отмене поездки с ID {ride_id}")



