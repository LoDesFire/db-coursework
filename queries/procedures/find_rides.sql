DELIMITER $$

CREATE PROCEDURE findRides(
  IN p_departure_station INT,
  IN p_arrival_station INT,
  IN p_date DATE,
  IN p_free_seats INT
)
BEGIN
  SELECT 
    rrs1.ride_id as id, 
    rrs1.id as departure_rrs_id,
    rrs2.id as arrival_rrs_id,
    planting_datetime, 
    departure_datetime, 
    arrival_datetime, 
    getFreeSeats(rrs1.ride_id) free_seats,
    (SELECT status FROM rides r WHERE r.id = rrs1.ride_id) status
  FROM 
    (SELECT rrs.id, ride_id, station_order_number, arrival_datetime as planting_datetime, departure_datetime
    FROM ride_route_stations AS rrs 
    INNER JOIN route_stations rs 
      ON rrs.route_stations_id = rs.id AND rs.station_id = p_departure_station) rrs1 
  INNER JOIN 
    (SELECT rrs.id, ride_id, station_order_number, arrival_datetime 
    FROM ride_route_stations AS rrs 
    INNER JOIN route_stations rs 
      ON rrs.route_stations_id = rs.id AND rs.station_id = p_arrival_station) rrs2 
  ON rrs1.ride_id = rrs2.ride_id 
  WHERE 
    rrs1.station_order_number < rrs2.station_order_number
    AND planting_datetime > NOW()
    AND (p_date IS NULL OR CAST(planting_datetime AS DATE) = p_date)
    AND (p_free_seats IS NULL OR getFreeSeats(rrs1.ride_id) >= p_free_seats);
END$$

DELIMITER ;