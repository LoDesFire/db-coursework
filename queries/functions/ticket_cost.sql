DELIMITER //

CREATE FUNCTION GetTicketCost(p_ticket_id INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE base_cost DECIMAL(10, 2);
    DECLARE travel_hours INT;
    DECLARE total_cost DECIMAL(10, 2);

    -- Calculate the base cost
    SELECT r.cost_base INTO base_cost
    FROM tickets t 
    JOIN ride_route_stations rrs ON rrs.id = t.departure_ride_route_station_id 
    JOIN rides r ON r.id = rrs.ride_id 
    WHERE t.id = p_ticket_id;

    -- Calculate travel hours
    SELECT TIMESTAMPDIFF(HOUR, rrsi.departure_datetime, rrsi2.arrival_datetime)
    INTO travel_hours
    FROM tickets t
    JOIN ride_route_stations rrsi 
        ON rrsi.id = t.departure_ride_route_station_id
    JOIN ride_route_stations rrsi2 
        ON rrsi2.id = t.arrival_ride_route_station_id
    WHERE t.id = p_ticket_id;

    -- Calculate total cost
    SELECT SUM(c.cost_coef * base_cost * (1 + (travel_hours * 0.1)))
    INTO total_cost
    FROM ticket_seats ts 
    JOIN seats s 
        ON s.id = ts.seat_id 
    JOIN cars c 
        ON c.id = s.car_id 
    WHERE ts.ticket_id = p_ticket_id;

    RETURN total_cost;
END //

DELIMITER ;