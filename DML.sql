-- Insert users
INSERT INTO
    users (register_datetime, login, email, password_hash)
VALUES
    (
        '2024-01-01 10:00:00',
        'jdoe',
        'jdoe@example.com',
        'a1b2c3d4e5f6231__asA'
    ),
    (
        '2024-01-02 11:00:00',
        'asmith',
        'asmith@example.com',
        'f6e5d4c3b2a1203-0sAS)=-1'
    ),
    (
        '2023-12-01 11:00:00',
        'mbrown',
        'mbrown@example.com',
        'z9y8x7w6v5uASK2123--4'
    ),
    (
        '2023-01-01 00:00:00',
        'lwilson',
        'lwilson@example.com',
        'u4v5w6x7asdd)_y8z9'
    );

-- Insert passports
INSERT INTO
    passports (
        serial_number,
        issue_date,
        expiration_date,
        country,
        issue_place
    )
VALUES
    (
        'A12345678',
        '2020-01-15',
        '2030-01-14',
        'United States',
        'New York'
    ),
    (
        'B98765432',
        '2021-06-20',
        '2031-06-19',
        'United Kingdom',
        'London'
    ),
    (
        'C12345678',
        '2019-03-05',
        '2029-03-04',
        'Canada',
        'Toronto'
    ), 
    (
        "D12839812",
        "2020-01-01",
        "2032-01-01",
        "Belarus",
        "Minsk"
    ),
    (
        "E87987987",
        "2019-12-12",
        "2100-10-12",
        "Poland",
        "Vilnius"
    ),
    (
        "F18391230", 
        "2019-10-23",
        "2050-10-10",
        "Poland",
        "Gdansk"
    );

-- Insert passengers
INSERT INTO
    passengers (
        user_id,
        passport_id,
        first_name,
        last_name,
        middle_name,
        phone_number
    )
VALUES
    (1, 1, 'Alexey', 'Ivanov', 'Petrovich', '+79261234567'),
    (2, 2, 'Maria', 'Kuznetsova', 'Sergeevna', '+375297654321'),
    (3, 3, 'Elena', 'Petrova', NULL, '+380503212345');

-- Insert roles
INSERT INTO
    roles (
        name,
        payment_refund_right,
        manage_routes_right,
        manage_roles_right,
        manage_employees_right
    )
VALUES
    ('Admin', true, true, true, true),
    ('Manager', true, true, false, false),
    ('Ticket stuff', true, false, false, false);

-- Insert employees
INSERT INTO
    employees (
        user_id,
        role_id,
        position,
        address,
        phone_number,
        first_name,
        last_name,
        middle_name
    )
VALUES
    (
        1,
        2,
        'General Manager',
        'ул. Ленина, д. 10, кв. 5',
        '+79261234567',
        'Алексей',
        'Иванов',
        'Петрович'
    );

-- Insert events_journal
INSERT INTO
    events_journal (
        user_id,
        datetime,
        action,
        table_name,
        primary_key,
        value_blob
    )
VALUES
    (
        1,
        '2024-01-01 10:00:00',
        'insert',
        'users',
        '1',
        '...'
    ),
    (
        2,
        '2024-01-02 11:00:00',
        'insert',
        'users',
        '2',
        '...'
    );


-- USER PART FILLING ===============================================
-- =================================================================
-- =================================================================
-- =================================================================

-- Insert stations
INSERT INTO
    stations (name, country, region)
VALUES
    ('Moscow Central', 'Russia', 'Moscow Region'),      -- 1
    (
        'Saint Petersburg Main',
        'Russia',
        'Leningrad Region'
    ),                                                  -- 2
    (
        'Nizhny Novgorod Station',
        'Russia',
        'Nizhny Novgorod Region'
    ),                                                  -- 3
    ('Kazan Railway', 'Russia', 'Tatarstan'),           -- 4
    ('Sochi Station', 'Russia', 'Krasnodar Krai'),      -- 5
    ('Minsk Central', 'Belarus', 'Minsk Region'),       -- 6
    ('Grodno Station', 'Belarus', 'Grodno Region'),     -- 7
    ('Brest Station', 'Belarus', 'Brest Region'),       -- 8
    ('Vitebsk Station', 'Belarus', 'Vitebsk Region'),   -- 9
    ('Gomel Station', 'Belarus', 'Gomel Region'),       -- 10
    ('Mogilev Station', 'Belarus', 'Mogilev Region'),       -- 11
    ('Vladivostok Station', 'Russia', 'Primorsky Krai'),  -- 12
    ('Yekaterinburg Station', 'Russia', 'Sverdlovsk Region'), -- 13
    ('Krasnoyarsk Station', 'Russia', 'Krasnoyarsk Krai'), -- 14
    ('Novosibirsk Station', 'Russia', 'Novosibirsk Oblast'), -- 15
    ('Samara Station', 'Russia', 'Samara Region'), -- 16
    ('Tashkent Station', 'Uzbekistan', 'Tashkent Region'), -- 17
    ('Almaty Station', 'Kazakhstan', 'Almaty Region'); -- 18


-- Insert route_stations
INSERT INTO
    route_stations (station_id, station_order_number)
VALUES
    -- Route from Nizhny Novgorod Station to Minsk
    (3, 1),
    (4, 2),
    (1, 3),
    (11, 4),
    (6, 5),
    -- Route from Tatarstan Station to Moscow
    (4, 1),
    (2, 2),
    (1, 3),
    -- Route from Nizhny Novgorod Station to Sochi Station
    (3, 1),   -- Нижний Новгород (Начальная станция)
    (4, 2),   -- Казань
    (1, 3),   -- Москва
    (5, 4),   -- Сочи (Конечная станция)
    -- Route from Kazan Railway to Minsk Central
    (4, 1),   -- Казань (Начальная станция)
    (1, 2),   -- Москва
    (11, 3),  -- Могилев
    (6, 4),   -- Минск (Конечная станция)
    -- Route from Sochi Station to Saint Petersburg Main
    (5, 1),   -- Сочи (Начальная станция)
    (1, 2),   -- Москва
    (2, 3),   -- Санкт-Петербург (Конечная станция)
    -- Route from Gomel Station to Grodno Station
    (10, 1),  -- Гомель (Начальная станция)
    (9, 2),   -- Витебск
    (7, 3),   -- Гродно (Конечная станция)
    -- Route from Екатеринбург to Красноярск
    (13, 1),   -- Екатеринбург (Начальная станция)
    (14, 2),   -- Красноярск (Конечная станция)
    -- Route from Novosibirsk Station to Krasnoyarsk Station
    (15, 1),   -- Новосибирск (Начальная станция)
    (14, 2),   -- Красноярск (Конечная станция)
    -- Route from Vladivostok Station to Novosibirsk Station
    (12, 1),   -- Владивосток (Начальная станция)
    (15, 2),   -- Новосибирск (Конечная станция)
    -- Route from Tashkent Station to Almaty Station
    (17, 1),   -- Ташкент (Начальная станция)
    (18, 2);   -- Алматы (Конечная станция)


-- Insert trains
INSERT INTO
    trains (name)
VALUES
    ('Sapsan'),
    ('Lastochka'),
    ('Nevsky Express'),
    ('Strizh'),
    ('Allegro');

-- Insert cars
-- Добавление вагонов с указанием владельца станции (station_owner_id) для поездов с ID от 1 до 5
INSERT INTO
    cars (category, class, cost_coef)
VALUES
    -- Вагоны для станции владельца с ID 1
    ('Passenger', 'First Class', 1),
    ('Passenger', 'Business Class', 1.5),
    ('Passenger', 'Economy Class', 0.8),
    -- Вагоны для станции владельца с ID 2
    ('Passenger', 'Economy Class', 0.8),
    ('Passenger', 'Business Class', 1.5),
    -- Вагоны для станции владельца с ID 3
    ('Passenger', 'First Class', 1),
    ('Passenger', 'Economy Class', 0.8),
    ('Dining', 'Restaurant', 0.00),
    -- Вагоны для станции владельца с ID 4
    ('Passenger', 'Business Class', 1.6),
    ('Passenger', 'Economy Class', 0.7),
    ('Sleeping', 'Luxury', 2.0),
    -- Вагоны для станции владельца с ID 5
    ('Passenger', 'Economy Class', 0.75),
    ('Dining', 'Restaurant', 0.00);

-- Привязка вагонов к поездам в таблице train_cars
INSERT INTO
    train_cars (train_id, car_id, car_order_number)
VALUES
    -- Привязка вагонов к поезду с ID 1 (Sapsan)
    (1, 1, 1),
    (1, 2, 2),
    (1, 3, 3),
    -- Привязка вагонов к поезду с ID 2 (Lastochka)
    (2, 4, 1),
    (2, 5, 2),
    -- Привязка вагонов к поезду с ID 3 (Nevsky Express)
    (3, 6, 1),
    (3, 7, 2),
    (3, 8, 3),
    -- Привязка вагонов к поезду с ID 4 (Strizh)
    (4, 9, 1),
    (4, 10, 2),
    (4, 11, 3),
    -- Привязка вагонов к поезду с ID 5 (Allegro)
    (5, 12, 1),
    (5, 13, 2);


-- Insert seats
-- Добавление мест для пассажирских вагонов
INSERT INTO
    seats (car_id, code)
VALUES
    -- Места для вагона с ID 1 (First Class)
    (1, 'A1'),
    (1, 'A2'),
    (1, 'A3'),
    -- Места для вагона с ID 2 (Business Class)
    (2, 'B1'),
    (2, 'B2'),
    (2, 'B3'),
    -- Места для вагона с ID 3 (Economy Class)
    (3, 'C1'),
    (3, 'C2'),
    (3, 'C3'),
    -- Места для вагона с ID 4 (Economy Class)
    (4, 'D1'),
    (4, 'D2'),
    (4, 'D3'),
    -- Места для вагона с ID 5 (Business Class)
    (5, 'E1'),
    (5, 'E2'),
    -- Места для вагона с ID 6 (First Class)
    (6, 'F1'),
    (6, 'F2'),
    -- Места для вагона с ID 7 (Economy Class)
    (7, 'G1'),
    (7, 'G2'),
    -- Места для вагона с ID 9 (Business Class)
    (9, 'H1'),
    (9, 'H2'),
    -- Места для вагона с ID 10 (Economy Class)
    (10, 'I1'),
    (10, 'I2');


-- RAILWAY FILLING =================================================
-- =================================================================
-- =================================================================
-- =================================================================
-- Insert rides
INSERT INTO
rides (
train_id,
departure_datetime,
arrival_datetime,
cost_base
)
VALUES
(
2, -- ID поезда (Sapsan)
'2024-12-18 03:00:00', -- Дата и время отправления (скорректировано)
'2024-12-19 09:30:00', -- Дата и время прибытия (скорректировано)
50.0
),
(
4, -- ID поезда (Strizh)
'2024-12-20 06:00:00', -- Дата и время отправления (скорректировано)
'2024-12-20 12:00:00', -- Дата и время прибытия (скорректировано)
60.0
),
(
1, -- Sapsan
'2024-12-22 07:00:00', -- Departure time (скорректировано)
'2024-12-22 14:00:00', -- Arrival time (скорректировано)
55.0
),
(
3, -- Nevsky Express
'2024-12-23 08:00:00',
'2024-12-23 15:00:00',
23.0
),
(
5, -- Allegro
'2024-12-25 09:00:00',
'2024-12-25 19:00:00',
70.0
),
(
2, -- Lastochka
'2024-12-26 10:00:00',
'2024-12-26 12:00:00',
66.0
),
(
4, -- Strizh
'2024-12-28 06:00:00',
'2024-12-28 10:00:00',
59.0
),
(
3, -- ID поезда (Sapsan)
'2024-12-18 03:00:00', -- Дата и время отправления (скорректировано)
'2024-12-19 09:30:00', -- Дата и время прибытия (скорректировано)
120.0
);



-- Insert ride_route_stations
INSERT INTO
ride_route_stations (
ride_id,
route_stations_id,
arrival_datetime,
departure_datetime
)
VALUES
-- Поездка 1, маршрут 1 (поезд с ID 2, маршрут от Nizhny Novgorod до Minsk)
(1, 1, '2024-12-18 05:30:00', '2024-12-18 05:45:00'), -- Nizhny Novgorod Station (начальная станция)
(1, 2, '2024-12-18 08:00:00', '2024-12-18 08:15:00'), -- Kazan Railway (промежуточная)
(1, 3, '2024-12-18 12:00:00', '2024-12-18 12:15:00'), -- Moscow Central (промежуточная)
(1, 4, '2024-12-18 18:30:00', '2024-12-18 18:45:00'), -- Mogilev Station (промежуточная)
(1, 5, '2024-12-19 09:15:00', NULL), -- Minsk Central (конечная станция)
-- Поездка 2, маршрут 2 (поезд с ID 4, маршрут от Kazan Railway до Moscow Central)
(2, 6, '2024-12-20 08:00:00', '2024-12-20 08:15:00'), -- Kazan Railway (начальная станция)
(2, 7, '2024-12-20 10:30:00', '2024-12-20 10:45:00'), -- Saint Petersburg Main (промежуточная)
(2, 8, '2024-12-20 12:00:00', NULL), -- Moscow Central (конечная станция)
-- Поездка 3, маршрут 3 (поезд с ID 1, маршрут от Nizhny Новгород до Сочи)
(3, 9, '2024-12-22 07:15:00', '2024-12-22 07:30:00'), -- Нижний Новгород Station (начальная станция)
(3, 10, '2024-12-22 10:00:00', '2024-12-22 10:15:00'), -- Казань Railway (промежуточная)
(3, 11, '2024-12-22 12:00:00', '2024-12-22 12:15:00'), -- Москва Central (промежуточная)
(3, 12, '2024-12-22 14:00:00', NULL), -- Сочи (конечная станция)
-- Поездка 4, маршрут 4 (поезд с ID 3, маршрут от Казани до Минска)
(4, 13, '2024-12-23 08:30:00', '2024-12-23 08:45:00'), -- Казань Railway (начальная станция)
(4, 14, '2024-12-23 10:00:00', '2024-12-23 10:15:00'), -- Москва Central (промежуточная)
(4, 15, '2024-12-23 12:00:00', '2024-12-23 12:15:00'), -- Могилев Station (промежуточная)
(4, 16, '2024-12-23 15:00:00', NULL), -- Минск Central (конечная станция)
   -- Поездка 5, маршрут 5 (поезд с ID 5, маршрут от Сочи до Санкт-Петербурга)
(5, 17, '2024-12-25 09:30:00', '2024-12-25 09:45:00'), -- Сочи (начальная станция)
(5, 18, '2024-12-25 12:00:00', '2024-12-25 12:15:00'), -- Москва Central (промежуточная)
(5, 19, '2024-12-25 19:00:00', NULL), -- Санкт-Петербург (конечная станция)
-- Поездка 6, маршрут 6 (поезд с ID 2, маршрут от Гомеля до Гродно)
(6, 20, '2024-12-26 10:15:00', '2024-12-26 10:30:00'), -- Гомель (начальная станция)
(6, 21, '2024-12-26 11:00:00', '2024-12-26 11:15:00'), -- Витебск (промежуточная)
(6, 22, '2024-12-26 12:00:00', NULL), -- Гродно (конечная станция)
-- Поездка 7, маршрут 7 (поезд с ID 4, маршрут от Екатеринбурга до Красноярска)
(7, 23, '2024-12-28 06:15:00', '2024-12-28 06:30:00'), -- Екатеринбург (начальная станция)
(7, 24, '2024-12-28 09:00:00', NULL), -- Красноярск (конечная станция)
-- Поездка 8, маршрут 8 (поезд с ID 2, маршрут от Nizhny Novgorod до Minsk)
(8, 1, '2024-12-18 05:30:00', '2024-12-18 05:45:00'), -- Nizhny Novgorod Station (начальная станция)
(8, 2, '2024-12-18 08:00:00', '2024-12-18 08:15:00'), -- Kazan Railway (промежуточная)
(8, 3, '2024-12-18 12:00:00', '2024-12-18 12:15:00'), -- Moscow Central (промежуточная)
(8, 4, '2024-12-18 18:30:00', '2024-12-18 18:45:00'), -- Mogilev Station (промежуточная)
(8, 5, '2024-12-19 09:15:00', NULL); -- Minsk Central (конечная станция)


-- Insert tickets
INSERT INTO
    tickets (
        passenger_id,
        departure_ride_route_station_id,
        arrival_ride_route_station_id
    )
VALUES
    (1, 1, 5),
    (2, 1, 3),
    (3, 7, 8);

-- Insert ticket_seats
INSERT INTO
    ticket_seats (ticket_id, seat_id)
VALUES
    (1, 10),
    (1, 11),
    (2, 14),
    (3, 21),
    (3, 20);