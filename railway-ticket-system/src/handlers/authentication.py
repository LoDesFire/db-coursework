from src.database import UserRepository


class Authentication:
    @staticmethod
    def signup():
        username = input("Введите имя пользователя: ")
        password = input("Введите пароль: ")
        email = input("Введите email: ")

        user = UserRepository.register_user(username, email, password)
        user_id = user
        if user is None:
            print("Ошибка регистрации")
            return
        if not user_id:
            return

        return user_id

    @staticmethod
    def login():
        username = input("Введите имя пользователя: ")
        password = input("Введите пароль: ")

        user_ids = UserRepository.authenticate_user(username, password)
        if not user_ids:
            return

        user_id = user_ids.get("id", None)

        # Выводим результат авторизации
        if not user_id:
            print("Ошибка авторизации: неверное имя пользователя или пароль.")
            return

        return user_ids.get("employee_id", None), user_id
