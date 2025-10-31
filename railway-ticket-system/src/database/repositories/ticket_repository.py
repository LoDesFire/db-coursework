from src.database import DatabaseConnection
from src.database.exception_handler_decorator import db_exception_handler
from src.database.repositories.employee_repository import EmployeeRepository


class TicketRepository:

    @staticmethod
    @db_exception_handler
    def get_tickets(user_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                """
SELECT t.id FROM tickets t
JOIN passengers p ON t.passenger_id = p.id 
JOIN users u ON p.user_id = u.id 
WHERE u.id = %s""",
                (user_id,)
            )
            tickets = cursor.fetchall()

            tickets_info = []
            for ticket in tickets:
                cursor.execute("CALL GetTicketInfo(%s)", (ticket['id'],))
                tickets_info.append(cursor.fetchone())
            return tickets_info


    @staticmethod
    @db_exception_handler
    def find_rides(departure_station_name, arrival_station_name, date, seat_count):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute("SELECT id FROM stations WHERE name = %s", (departure_station_name,))
            departure_station_id = cursor.fetchone()
            if not departure_station_id:
                return None
            departure_station_id = departure_station_id.get("id", None)
            cursor.execute("SELECT id FROM stations WHERE name = %s", (arrival_station_name,))
            arrival_station_id = cursor.fetchone()
            if not arrival_station_id:
                return None
            arrival_station_id = arrival_station_id.get("id", None)
            cursor.execute(
                "CALL findRides(%s, %s, %s, %s)",
                (departure_station_id, arrival_station_id, date, seat_count)
            )
            return cursor.fetchall()

    @staticmethod
    @db_exception_handler
    def create_ticket(departure_rrs_id, arrival_rrs_id, passenger_id, seats):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO tickets (departure_ride_route_station_id, arrival_ride_route_station_id, passenger_id, status) VALUES (%s, %s, %s, %s);",
                (departure_rrs_id, arrival_rrs_id, passenger_id, "OK")
            )
            ticket_id = cursor.lastrowid
            for seat in seats:
                cursor.execute(
                    "CALL AddSeatToTicket(%s, %s)",
                    (ticket_id, seat)
                )
        cxn.commit()
        return ticket_id

    @staticmethod
    @db_exception_handler
    def refund_ticket(employee_id, ticket_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            employee = EmployeeRepository.get_employee_with_role(employee_id)
            if not employee or not employee['manage_routes_right']:
                print("У вас нет прав на возврат билетов.")
                return None

            cursor.execute(
                "UPDATE tickets SET status = 'CANCELED' WHERE id = %s",
                (ticket_id,)
            )
        cxn.commit()
        return True
