DELIMITER //

CREATE PROCEDURE GetTicketInfo(
    IN p_ticket_id INT
)
BEGIN
    SELECT 
        t.id,
        rrs2.departure_datetime AS departure_time,
        rrs.arrival_datetime AS arrival_time,
        s2.name AS departure_station,
        s.name AS arrival_station,
        t.status,
        t.cost AS cost
    FROM tickets t 
    JOIN ride_route_stations rrs ON rrs.id = t.arrival_ride_route_station_id
    JOIN ride_route_stations rrs2 ON rrs2.id = t.departure_ride_route_station_id 
    JOIN route_stations rs ON rrs.route_stations_id = rs.id 
    JOIN route_stations rs2 ON rrs2.route_stations_id = rs2.id 
    JOIN stations s ON rs.station_id = s.id 
    JOIN stations s2 ON rs2.station_id = s2.id 
    WHERE t.id = p_ticket_id;
END //

DELIMITER ;