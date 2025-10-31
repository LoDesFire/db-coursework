CREATE  TRIGGER user_tickets_insert_trigger 
AFTER INSERT ON tickets
FOR EACH ROW 
INSERT INTO events_journal(user_id, `datetime`, `action`, table_name, primary_key, value_blob)
VALUES(
	(SELECT MAX(p.user_id) user_id FROM passengers p WHERE p.id = NEW.passenger_id), 
	NOW(),
	"insert",
	"tickets",
	NEW.id,
	CONCAT(
		CONVERT((SELECT CONCAT(p.last_name, "-", p.first_name) FROM passengers p WHERE p.id = NEW.passenger_id),char), "_",
		CONVERT(NEW.departure_ride_route_station_id,char), "_",
		CONVERT(NEW.arrival_ride_route_station_id,char), "_",
		CONVERT(NEW.cost,char))
)
DROP TRIGGER  user_tickets_insert_trigger ;