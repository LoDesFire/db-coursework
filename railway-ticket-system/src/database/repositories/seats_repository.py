from src.database import DatabaseConnection
from src.database.exception_handler_decorator import db_exception_handler


class SeatsRepository:

    @staticmethod
    @db_exception_handler
    def get_ticket_seats(ticket_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            query = """
SELECT s.id, s.code, c.category, c.class, c.cost_coef
FROM seats s
JOIN cars c ON s.car_id = c.id
JOIN ticket_seats ts ON s.id = ts.seat_id
WHERE ts.ticket_id = %s;
            """
            cursor.execute(query, (ticket_id,))
        return cursor.fetchall()


    @staticmethod
    @db_exception_handler
    def get_available_seats_by_ride(ride_id):
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            query = """
SELECT s.id, s.code, c.category, c.class, c.cost_coef 
FROM seats s
JOIN cars c ON s.car_id = c.id
JOIN train_cars tc ON c.id = tc.car_id
JOIN rides r ON r.train_id = tc.train_id
WHERE r.id = %s
AND s.id NOT IN (
  SELECT ts.seat_id
  FROM ticket_seats ts
  JOIN tickets t ON ts.ticket_id = t.id
  JOIN ride_route_stations rrs ON rrs.id = t.departure_ride_route_station_id
  WHERE (t.status IS NULL OR t.status NOT IN ("CANCELED")) AND  rrs.ride_id = %s);
    """
            cursor.execute(query, (ride_id, ride_id))
            seats = cursor.fetchall()
            return seats
