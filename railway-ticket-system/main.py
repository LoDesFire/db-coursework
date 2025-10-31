from src.handlers import Authentication, User, Employee
from src.database import DatabaseConnection


def main():
    with DatabaseConnection():
        while True:
            print("Выберите действие:")
            print("1. Авторизация")
            print("2. Регистрация")
            print("0. Выход")

            choice = input("Введите номер действия: ")
            match choice:
                case "1":
                    login_response = Authentication.login()
                    if not login_response:
                        continue
                    employee_id, user_id = login_response
                    if not user_id:
                        continue
                    if not employee_id:
                        User(user_id).run()
                    else:
                        Employee(user_id, employee_id).run()
                case "2":
                    user_id = Authentication.signup()
                    if not user_id:
                        continue
                    User(user_id).run()
                case "0":
                    print("Выход из программы.")
                    break
                case _:
                    print("Неправильный выбор. Пожалуйста, выберите действие снова.")


if __name__ == '__main__':
    main()
