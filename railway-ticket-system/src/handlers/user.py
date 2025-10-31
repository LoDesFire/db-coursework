import datetime

from src.database import UserRepository
from src.database.repositories.passenger_repository import PassengerRepository
from src.database.repositories.rides_repository import RidesRepository
from src.database.repositories.seats_repository import SeatsRepository
from src.database.repositories.ticket_repository import TicketRepository


class User:
    def __init__(self, user_id):
        self.user_id = user_id
        self.hello_message()

    def hello_message(self):
        print("Успешно авторизован как пользователь!")

    def run(self):
        while True:
            try:
                print("1. Просмотр профиля")
                print("2. Редактирование профиля")
                print("3. Купить билет")
                print("4. Мои билеты")
                print("5. Управление пассажирами")
                print("6. Все маршруты")
                print("0. Выход")
                choice = input("Выберите действие: ")
                match choice:
                    case "1":
                        self.view_profile()
                    case "2":
                        self.edit_profile()
                    case "3":
                        self.buy_tickets()
                    case "4":
                        self.get_tickets()
                    case "5":
                        self.passenger_crud()
                    case "6":
                        self.all_routes()
                    case "0":
                        break
                    case _:
                        print("Недопустимый выбор")
            except Exception as e:
                print(f"Произошла ошибка: {e}")

    def view_profile(self):
        user_info = UserRepository.get_user(self.user_id)
        print("Профиль пользователя:", user_info)

    def edit_profile(self):
        email = input("Введите новый email (оставьте пустым, если не хотите изменять): ")
        login = input("Введите новый логин (оставьте пустым, если не хотите изменять): ")
        password = input("Введите новый пароль (оставьте пустым, если не хотите изменять): ")

        email = email if email else None
        login = login if login else None
        password = password if password else None

        UserRepository.update_user(self.user_id, email, login, password)
        print("Профиль обновлен")

    @staticmethod
    def all_routes():
        rides = RidesRepository.get_all_rides()
        for ix, r in enumerate(rides, start=1):
            print(f"""
Поездка #{ix}
{r['departure_station']} ({r['departure_datetime'].strftime("%Y.%m.%d %H:%M")}) – {r['arrival_station']} ({r['arrival_datetime'].strftime("%Y.%m.%d %H:%M")})""")

    @staticmethod
    def search_rides():
        while True:
            departure_station = input("Введите название станции отбытия: ")
            arrival_station = input("Введите название станции прибытия: ")
            date = None
            while date is None:
                date = input("Введите дату в формате YYYY-MM-DD (оставьте пустым, если не хотите указывать): ")
                if date == "":
                    date = None
                    break
                date = datetime.datetime.strptime(date, "%Y-%m-%d") if date else None
                if date is None:
                    print("Неверная дата")

            seat_count = input("Введите количество мест (оставьте пустым, если не хотите указывать): ")

            rides = TicketRepository.find_rides(
                departure_station,
                arrival_station,
                None if not date else date,
                None if not seat_count else int(seat_count)
            )

            if rides:
                print("Найденные поездки:")
                for ix, ticket in enumerate(rides, start=1):
                    print(f"{ix}. {ticket}")
            else:
                print("Билеты не найдены.")
                return None
            ride_number = 0
            while True:
                try:
                    ride_number = int(input("Введите номер поездки: "))
                    break
                except Exception:
                    print("Неверный номер поездки")
                    continue
            if ride_number == 0:
                return None
            ride = rides[ride_number - 1] if 0 < ride_number <= len(rides) else None
            if ride is None:
                return None
            else:
                ride.update({
                    "departure_station": departure_station,
                    "arrival_station": arrival_station
                })
            return ride

    def get_tickets(self):
        tickets = TicketRepository.get_tickets(self.user_id)
        for ticket in tickets:
            print(f"Станция отправления: {ticket['departure_station']}")
            print(f"Время отправления: {ticket['departure_time'].strftime('%Y-%m-%d %H:%M')}")
            print(f"Станция прибытия: {ticket['arrival_station']}")
            print(f"Время прибытия: {ticket['arrival_time'].strftime('%Y-%m-%d %H:%M')}")
            print(f"Статус: {ticket['status']}")
            print(f"Стоимость: {ticket['cost']}")
            print(f"Места:")
            seats = SeatsRepository.get_ticket_seats(ticket['id'])
            for s in seats:
                print(f"Место {s['code']} (Категория: {s['category']}, Класс: {s['class']})")
            print("-" * 40)
    def buy_tickets(self):
        ride = self.search_rides()
        if ride is None:
            return
        print(
            f"{ride['departure_station']} – {ride['arrival_station']} ({ride['departure_datetime'].strftime('%Y.%m.%d %H:%M')} – {ride['arrival_datetime'].strftime('%Y.%m.%d %H:%M')})")
        available_seats = SeatsRepository.get_available_seats_by_ride(ride['id'])
        if not available_seats:
            print("Нет доступных мест для этой поездки.")
            return
        print("Доступные места:")
        for ix, seat in enumerate(available_seats, start=1):
            print(
                f"{ix}. Место {seat['code']} (Категория: {seat['category']}, Класс: {seat['class']}, Коэффициент стоимости: {seat['cost_coef']})")

        selected_seats = input("Введите номера мест через запятую: ").split(',')
        selected_seats = [int(seat.strip()) for seat in selected_seats]

        seat_ids = [seat["id"] for ix, seat in enumerate(available_seats, start=1) if ix in selected_seats]
        if not seat_ids:
            print("Неверные номера мест.")
            return

        passenger_id = self.get_passenger_id()
        if not passenger_id:
            return

        ticket_id = TicketRepository.create_ticket(
            ride['departure_rrs_id'],
            ride['arrival_rrs_id'],
            passenger_id,
            seat_ids
        )
        print(f"Билет успешно создан. ID билета: {ticket_id}")

    def passenger_crud(self):
        while True:
            try:
                print("1. Все пассажиры")
                print("2. Создать пассажира")
                print("3. Обновить пассажира")
                print("4. Удалить пассажира")
                print("0. Назад")
                choice = input("Выберите действие: ")
                if choice == "1":
                    self.read_passengers()
                elif choice == "2":
                    self.create_passenger()
                elif choice == "3":
                    self.update_passenger()
                elif choice == "4":
                    self.delete_passenger()
                elif choice == "0":
                    break
                else:
                    print("Недопустимый выбор")
            except Exception as e:
                print(f"Произошла ошибка: {e}")

    def create_passenger(self):
        first_name = input("Введите имя пассажира: ")
        last_name = input("Введите фамилию пассажира: ")
        middle_name = input("Введите отчество пассажира (оставьте пустым, если не хотите указывать): ")
        phone_number = input("Введите номер телефона пассажира (оставьте пустым, если не хотите указывать): ")

        passport = {
            'serial_number': input("Введите серию паспорта (оставьте пустым, если не хотите указывать): "),
            'issue_date': input("Введите дату выдачи паспорта (оставьте пустым, если не хотите указывать): "),
            'expiration_date': input(
                "Введите дату окончания действия паспорта (оставьте пустым, если не хотите указывать): "),
            'country': input("Введите страну выдачи паспорта (оставьте пустым, если не хотите указывать): "),
            'issue_place': input("Введите место выдачи паспорта (оставьте пустым, если не хотите указывать): ")
        }

        # Удаляем пустые значения из словаря паспорта
        passport = {k: v for k, v in passport.items() if v}

        passenger_id = PassengerRepository.create_passenger(
            self.user_id, first_name, last_name, middle_name or None, phone_number or None, passport or None
        )
        print(f"Пассажир создан.\n")

    def read_passengers(self):
        passengers = PassengerRepository.read_passengers(self.user_id)
        if not passengers:
            print("Нет пассажиров\n")
            return
        print("Все пассажиры:")
        for passenger in passengers:
            print(f"- {passenger['first_name']} {passenger['last_name']}")
        print("\n")

    def get_passenger_id(self):
        passengers = PassengerRepository.read_passengers(self.user_id)
        if not passengers:
            print("Нет пассажиров\n")
            return

        for idx, passenger in enumerate(passengers, start=1):
            print(f"{idx}. {passenger['first_name']} {passenger['last_name']}")

        passenger_number = int(input("Введите номер пассажира: "))
        if 1 <= passenger_number <= len(passengers):
            passenger_id = passengers[passenger_number - 1]['id']
            return passenger_id
        else:
            print("Неправильный номер пассажира\n")
            return

    def update_passenger(self):
        passenger_id = self.get_passenger_id()
        if passenger_id is None:
            return

        name = input("Введите новое имя пассажира (оставьте пустым, если не хотите изменять): ")
        age = input("Введите новый возраст пассажира (оставьте пустым, если не хотите изменять): ")
        passport_number = input("Введите новый номер паспорта пассажира (оставьте пустым, если не хотите изменять): ")

        name = name if name else None
        age = age if age else None
        passport_number = passport_number if passport_number else None

        PassengerRepository.update_passenger(passenger_id, name, age, passport_number)
        print("Информация о пассажире обновлена\n")

    def delete_passenger(self):
        passenger_id = self.get_passenger_id()
        if passenger_id is None:
            return
        PassengerRepository.delete_passenger(passenger_id)
        print("Пассажир удален\n")
