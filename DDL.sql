CREATE DATABASE study;
USE study;
 
CREATE TABLE
    users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        register_datetime DATETIME NOT NULL DEFAULT NOW(),
        login VARCHAR(30) NOT NULL,
        email VARCHAR(30) NOT NULL,
        password_hash TEXT NOT NULL
    );

CREATE TABLE
    passengers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT UNIQUE NOT NULL,
        passport_id INT UNIQUE,
        first_name VARCHAR(20) NOT NULL,
        last_name VARCHAR(20) NOT NULL,
        middle_name VARCHAR(20),
        phone_number VARCHAR(20)
    );
ALTER TABLE `passengers` ADD CONSTRAINT FK_passengers_user_id FOREIGN KEY (user_id) REFERENCES users (id);


CREATE TABLE
    passports (
        id INT AUTO_INCREMENT PRIMARY KEY,
        serial_number VARCHAR(20) NOT NULL,
        issue_date DATE NOT NULL,
        expiration_date DATE NOT NULL,
        country VARCHAR(30) NOT NULL,
        issue_place VARCHAR(70) NOT NULL
    );
ALTER TABLE `passengers` ADD CONSTRAINT FK_passengers_passport_id FOREIGN KEY (passport_id) REFERENCES passports (id) ON DELETE CASCADE;

CREATE TABLE
    roles (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        payment_refund_right BOOLEAN DEFAULT false,
        manage_routes_right BOOLEAN DEFAULT false,
        manage_roles_right BOOLEAN DEFAULT false, 
        manage_employees_right BOOLEAN DEFAULT false
    );

CREATE TABLE
    employees (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT UNIQUE NOT NULL,
        role_id INT,
        position VARCHAR(20) NOT NULL,
        address VARCHAR(100),
        phone_number VARCHAR(20),
        first_name VARCHAR(20) NOT NULL,
        last_name VARCHAR(20) NOT NULL,
        middle_name VARCHAR(20)
    );
ALTER TABLE `employees` ADD CONSTRAINT FK_employees_user_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE `employees` ADD CONSTRAINT FK_employees_role_id FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE SET NULL;

CREATE TABLE
    events_journal (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        datetime DATETIME NOT NULL,
        action enum("delete", "insert", "update") NOT NULL,
        table_name VARCHAR(20) NOT NULL,
        primary_key BLOB NOT NULL,
        value_blob BLOB
    );
ALTER TABLE `events_journal` ADD CONSTRAINT FK_events_journal_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;


CREATE TABLE
    stations (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(30) NOT NULL,
        country VARCHAR(30) NOT NULL,
        region VARCHAR(30)
    );

CREATE TABLE
    tickets (
        id INT AUTO_INCREMENT PRIMARY KEY,
        passenger_id INT NOT NULL,
        departure_ride_route_station_id INT NOT NULL,
        arrival_ride_route_station_id INT NOT NULL,
        cost DECIMAL(10, 2) NOT NULL DEFAULT 0,
        `status` varchar(100) DEFAULT NULL
    );
ALTER TABLE `tickets` ADD CONSTRAINT FK_tickets_passenger_id FOREIGN KEY (passenger_id) REFERENCES passengers (id);


CREATE TABLE
    ticket_seats (
        ticket_id INT NOT NULL,
        seat_id INT NOT NULL,
        PRIMARY KEY (ticket_id, seat_id)
    );
ALTER TABLE `ticket_seats` ADD CONSTRAINT FK_ticket_seats_ticket_id FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE CASCADE;


CREATE TABLE
    seats (
        id INT AUTO_INCREMENT PRIMARY KEY,
        car_id INT NOT NULL,
        code VARCHAR(10) NOT NULL
    );
ALTER TABLE `ticket_seats` ADD CONSTRAINT FK_ticket_seats_seat_id FOREIGN KEY (seat_id) REFERENCES seats (id);

CREATE TABLE
    cars (
        id INT AUTO_INCREMENT PRIMARY KEY,
        category VARCHAR(20),
        class VARCHAR(20),
        cost_coef DECIMAL(10, 2) NOT NULL
    );
ALTER TABLE `seats` ADD CONSTRAINT FK_seats_car_id FOREIGN KEY (car_id) REFERENCES cars (id) ON DELETE CASCADE;
   
CREATE TABLE
    train_cars (
        train_id INT NOT NULL,
        car_id INT NOT NULL,
        car_order_number INT NOT NULL,
        PRIMARY KEY (train_id, car_id)
    );
ALTER TABLE `train_cars` ADD CONSTRAINT FK_train_cars_cars_id FOREIGN KEY (car_id) REFERENCES cars (id);

CREATE TABLE
    trains (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(30) UNIQUE NOT NULL
    );
ALTER TABLE `train_cars` ADD CONSTRAINT FK_train_cars_train_id FOREIGN KEY (train_id) REFERENCES trains (id) ON DELETE CASCADE;

CREATE TABLE
    rides (
        id INT AUTO_INCREMENT PRIMARY KEY,
        train_id INT NOT NULL,
        departure_datetime DATETIME NOT NULL,
        arrival_datetime DATETIME NOT NULL,
        cost_base DECIMAL(10, 2) NOT NULL,
        `status` varchar(100) DEFAULT NULL
    );
ALTER TABLE `rides` ADD CONSTRAINT FK_rides_train_id FOREIGN KEY (train_id) REFERENCES trains (id); 

CREATE TABLE
    route_stations (
        id INT AUTO_INCREMENT PRIMARY KEY,
        station_id INT NOT NULL,
        station_order_number INT NOT NULL
    );
ALTER TABLE `route_stations` ADD CONSTRAINT FK_route_stations_station_id FOREIGN KEY (station_id) REFERENCES stations (id) ON DELETE CASCADE;

CREATE TABLE
    ride_route_stations (
        id INT AUTO_INCREMENT PRIMARY KEY,
        ride_id INT NOT NULL,
        route_stations_id INT NOT NULL,
        arrival_datetime DATETIME NOT NULL,
        departure_datetime DATETIME
    );
ALTER TABLE `ride_route_stations` ADD CONSTRAINT FK_ride_route_stations_ride_id FOREIGN KEY (ride_id) REFERENCES rides (id) ON DELETE CASCADE;
ALTER TABLE `ride_route_stations` ADD CONSTRAINT FK_ride_route_stations_route_stations_id FOREIGN KEY (route_stations_id) REFERENCES route_stations (id) ;
ALTER TABLE `tickets` ADD CONSTRAINT FK_tickets_departure_ride_route_station_id FOREIGN KEY (departure_ride_route_station_id) REFERENCES ride_route_stations (id);
ALTER TABLE `tickets` ADD CONSTRAINT FK_tickets_arrival_ride_route_station_id FOREIGN KEY (arrival_ride_route_station_id) REFERENCES ride_route_stations (id);
