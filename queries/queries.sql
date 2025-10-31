-- =============================================
-- Аутентификация пользователя
SELECT * 
FROM users 
WHERE login = 'user_login' AND password_hash = SHA2('user_password', 256);

-- =============================================
-- Управление пользователями
INSERT INTO users (register_datetime, login, email, password_hash)
VALUES (NOW(), 'user_login', 'user_email', SHA2('user_password', 256));

UPDATE users 
SET login = 'new_login', email = 'new_email', password_hash = SHA2('new_user_password', 256)
WHERE id = user_id;

DELETE FROM users WHERE id = user_id;

SELECT * FROM users WHERE id = user_id;

-- Получение электронной почты людей и количества пассажиров на их пользователе в порядке убывания
SELECT u.email, p_cnt.count 
FROM users u, (
	SELECT COUNT(*) count, p.user_id user_id
	FROM passengers p
	GROUP BY p.user_id
	HAVING COUNT(*) > 1) p_cnt
WHERE u.id = p_cnt.user_id
ORDER BY p_cnt.count DESC

-- =============================================
-- Проверка прав пользователя (например, на возврат билета):

SELECT r.payment_refund_right
FROM users u
JOIN employees e 
	ON u.id = e.user_id
JOIN roles r 
	ON e.role_id = r.id
WHERE u.id = user_id;

-- =============================================
-- Журналирование действий пользователя
INSERT INTO events_journal (user_id, datetime, action, table_name, primary_key, value_blob)
VALUES (user_id, NOW(), 'insert', 'tickets', primary_key_value, value_blob_value);

-- =============================================
-- Управление пассажирами 
INSERT INTO passengers (user_id, passport_id, first_name, last_name, middle_name, phone_number)
VALUES (user_id, passport_id, 'first_name', 'last_name', 'middle_name', 'phone_number');

UPDATE passengers 
SET first_name = 'new_first_name', last_name = 'new_last_name'
WHERE id = passenger_id;

DELETE FROM passengers 
WHERE id = passenger_id;

SELECT * FROM passengers 
WHERE id = passenger_id;

SELECT p.id, p.first_name, p.last_name
FROM passengers p 
WHERE p.passport_id IS NULL

-- =============================================
-- Поиск по дате, станциям отъезда и высадки
SELECT rrs1.ride_id FROM 
		(SELECT rrs.id, ride_id, station_order_number, arrival_datetime 
		FROM study.ride_route_stations AS rrs 
		INNER JOIN study.route_stations rs 
			ON rrs.route_stations_id = rs.id AND rs.station_id = first_station_id) rrs1 
	INNER JOIN 
		(SELECT rrs.id, ride_id, station_order_number 
		FROM study.ride_route_stations AS rrs 
		INNER JOIN study.route_stations rs 
			ON rrs.route_stations_id = rs.id AND rs.station_id = second_station_id) rrs2 
	ON rrs1.ride_id = rrs2.ride_id 
		AND rrs1.station_order_number < rrs2.station_order_number
		AND DATEDIFF(rrs1.arrival_datetime, user_departure_datetime) = 0;

-- Получение остановок между начальной и конечной остановками 
WITH ordered_route_station AS (
	SELECT rs.station_order_number, rs.station_id
	FROM ride_route_stations rrs, route_stations rs 
	WHERE rrs.route_stations_id = rs.id 
		AND rrs.ride_id = 1
)
SELECT 
SELECT o2.station_order_number, o2.station_id
FROM (
	SELECT * 
	FROM ordered_route_station o1
	WHERE 
		o1.station_order_number <= (
			SELECT MAX(o.station_order_number) 
			FROM ordered_route_station o 
			WHERE o.station_id = 11
		)
		AND 
		o1.station_order_number >= (
			SELECT MIN(o.station_order_number) 
			FROM ordered_route_station o 
			WHERE o.station_id = 4
		)
	) o1
RIGHT JOIN ordered_route_station o2
	ON o1.station_id = o2.station_id
WHERE o1.station_id IS NULL

-- получение свободных мест в поезде для выбранных начальной и конечной остановок и выбранной поездки
-- хм..

-- =============================================
-- Выбор мест в поезде
INSERT INTO ticket_seats (ticket_id, seat_id)
VALUES (ticket_id_value, seat_id_value);

-- =============================================
-- Покупка/Возврат билетов
INSERT INTO tickets (passenger_id, departure_station_id, arrival_station_id, ride_id, cost)
VALUES (passenger_id_value, departure_station_id_value, arrival_station_id_value, ride_id_value, ticket_cost);

DELETE FROM tickets 
WHERE id = ticket_id;

-- =============================================
-- Отмена выезда по маршруту
DELETE FROM rides 
WHERE id = ride_id;

-- =============================================
-- Управление сотрудниками
INSERT INTO employees (user_id, role_id, position, address, phone_number, first_name, last_name, middle_name)
VALUES (user_id_value, role_id_value, 'position_value', 'address_value', 'phone_number_value', 'first_name_value', 'last_name_value', 'middle_name_value');

SELECT * 
FROM employees 
WHERE id = employee_id;

UPDATE employees 
SET position = 'new_position', address = 'new_address', phone_number = 'new_phone_number'
WHERE id = employee_id;

DELETE FROM employees 
WHERE id = employee_id;

-- =============================================
-- Управление ролями 
INSERT INTO roles (name, payment_refund_right, manage_routes_right, manage_roles_right, manage_employees_right)
VALUES ('role_name', true, false, true, true);

SELECT * 
FROM roles 
WHERE id = role_id;

UPDATE employees 
SET role_id = role_id_value 
WHERE user_id = user_id;

UPDATE roles 
SET name = 'new_role_name', payment_refund_right = false
WHERE id = role_id;

DELETE FROM roles 
WHERE id = role_id;
		