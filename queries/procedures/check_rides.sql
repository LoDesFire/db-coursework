-- Проверка существования поездки по станции отправления, станции прибытия и даты

DELIMITER //
CREATE PROCEDURE check_ride(
	IN dep_st integer, 
	IN arrival_st integer, 
	IN check_ride_id integer
)
BEGIN	
	DECLARE 
		msg varchar(255);

	SELECT (SELECT rrs1.ride_id FROM 
		(SELECT rrs.id, ride_id, station_order_number, arrival_datetime 
		FROM study.ride_route_stations AS rrs 
		INNER JOIN study.route_stations rs 
			ON rrs.route_stations_id = rs.id AND rs.station_id = dep_st
		) rrs1 
	INNER JOIN 
		(SELECT rrs.id, ride_id, station_order_number 
		FROM study.ride_route_stations AS rrs 
		INNER JOIN study.route_stations rs 
			ON rrs.route_stations_id = rs.id AND rs.station_id = arrival_st
		) rrs2 
	ON rrs1.ride_id = rrs2.ride_id 
		AND rrs1.station_order_number < rrs2.station_order_number
		AND rrs1.ride_id = check_ride_id) IS NULL INTO @ride_found; 
	
	if @ride_found then
        SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'FAILED ride check. Ride is not suitable for stations';
    end if;
END //
DELIMITER ;

drop procedure check_ride;