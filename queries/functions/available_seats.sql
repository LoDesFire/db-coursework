DELIMITER $$

CREATE FUNCTION getFreeSeats(p_ride_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE free_seats INT;
    SELECT COUNT(*)
    INTO free_seats
    FROM seats s
    JOIN train_cars tc ON s.car_id = tc.car_id
    JOIN rides r ON r.train_id = tc.train_id
    WHERE r.id = p_ride_id
        AND s.id NOT IN (
        SELECT ts.seat_id
        FROM ticket_seats ts
        JOIN tickets t ON ts.ticket_id = t.id
        JOIN ride_route_stations rrs ON rrs.id = t.departure_ride_route_station_id
        WHERE (t.status IS NULL OR t.status NOT IN ("CANCELED")) AND  rrs.ride_id = p_ride_id
        );
    RETURN free_seats;
END$$

DELIMITER ;


