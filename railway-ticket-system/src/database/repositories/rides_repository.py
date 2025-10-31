from src.database import DatabaseConnection
from src.database.exception_handler_decorator import db_exception_handler


class RidesRepository:

    @staticmethod
    @db_exception_handler
    def get_all_rides():
        cxn = DatabaseConnection().connection
        with cxn.cursor() as cursor:
            query = """
                    SELECT ride_id, 
                    (
                        SELECT s2.name FROM ride_route_stations rrs2
                        JOIN route_stations rs2 ON rrs2.route_stations_id = rs2.id 
                        JOIN stations s2 ON s2.id = rs2.station_id
                        WHERE rrs2.ride_id = rrs.ride_id AND rs2.station_order_number = MIN(rs.station_order_number)
                    ) departure_station,
                    (
                        SELECT s2.name FROM ride_route_stations rrs2
                        JOIN route_stations rs2 ON rrs2.route_stations_id = rs2.id 
                        JOIN stations s2 ON s2.id = rs2.station_id
                        WHERE rrs2.ride_id = rrs.ride_id AND rs2.station_order_number = MAX(rs.station_order_number)
                    ) arrival_station,
                    (SELECT r1.departure_datetime FROM rides r1 WHERE r1.id = ride_id) departure_datetime,
                    (SELECT r1.arrival_datetime FROM rides r1 WHERE r1.id = ride_id) arrival_datetime 
                    FROM ride_route_stations rrs 
                    JOIN route_stations rs ON rrs.route_stations_id = rs.id 
                    GROUP BY ride_id 
                    HAVING (SELECT r1.arrival_datetime FROM rides r1 WHERE r1.id = ride_id) > NOW() AND (SELECT r2.status FROM rides r2 WHERE r2.id = ride_id) IS NULL;                   
                    """
            cursor.execute(query)
            rides = cursor.fetchall()
            return rides
