DELIMITER //

CREATE TRIGGER UpdateTicketCostAfterInsert
AFTER INSERT ON ticket_seats
FOR EACH ROW
BEGIN
    DECLARE updated_cost DECIMAL(10, 2);
    DECLARE seat_count INT;
   	DECLARE train_id INT;
    DECLARE seat_train_id INT;

    -- Check if the seat is already occupied
    SELECT COUNT(*) INTO seat_count
    FROM ticket_seats
    WHERE seat_id = NEW.seat_id;

    -- Verify the seat belongs to the correct train
    SELECT r.train_id INTO train_id
    FROM tickets t
    JOIN ride_route_stations rrs ON t.departure_ride_route_station_id = rrs.id
    JOIN rides r ON rrs.ride_id = r.id
    WHERE t.id = NEW.ticket_id;

    SELECT tc.train_id INTO seat_train_id
    FROM seats s
    JOIN cars c ON s.car_id = c.id
    JOIN train_cars tc ON c.id = tc.car_id
    WHERE s.id = NEW.seat_id;

    IF train_id != seat_train_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat does not belong to the correct train.';
    END IF;

    -- Recalculate the ticket cost after a new seat is added
    SET updated_cost = GetTicketCost(NEW.ticket_id);

    -- Update the ticket's cost in the tickets table
    UPDATE tickets
    SET cost = updated_cost
    WHERE id = NEW.ticket_id;
END //

DELIMITER ;
