DELIMITER //

CREATE TRIGGER UpdateTicketStatuses
AFTER UPDATE ON rides
FOR EACH ROW
BEGIN
    IF NEW.status = "CANCELED" THEN
        UPDATE tickets t
        JOIN ride_route_stations rrs ON rrs.id = t.departure_ride_route_station_id
        SET t.status = "CANCELED"
        WHERE rrs.ride_id = NEW.id;
    END IF;
END //

DELIMITER ;
