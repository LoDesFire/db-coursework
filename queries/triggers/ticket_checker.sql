DELIMITER //

CREATE TRIGGER check_ticket_constraints
BEFORE INSERT ON tickets
FOR EACH ROW
BEGIN
    DECLARE departure_ride_id INT;
    DECLARE arrival_ride_id INT;
    DECLARE departure_time DATETIME;
    DECLARE arrival_time DATETIME;

    -- Получение ride_id для станции отправления
    SELECT ride_id, arrival_datetime INTO departure_ride_id, departure_time
    FROM ride_route_stations
    WHERE id = NEW.departure_ride_route_station_id;

    -- Получение ride_id для станции прибытия
    SELECT ride_id, arrival_datetime INTO arrival_ride_id, arrival_time
    FROM ride_route_stations
    WHERE id = NEW.arrival_ride_route_station_id;

    -- Проверка, что обе станции принадлежат одному рейсу
    IF departure_ride_id != arrival_ride_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Departure and arrival stations must belong to the same ride.';
    END IF;
END//

DELIMITER ;