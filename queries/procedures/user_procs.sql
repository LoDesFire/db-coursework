DELIMITER //

CREATE PROCEDURE CreateUser(
    IN p_login VARCHAR(30),
    IN p_email VARCHAR(30),
    IN p_password TEXT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM users
        WHERE login = p_login OR email = p_email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User with this login or email already exists';
    ELSE
        INSERT INTO users (login, email, password_hash)
        VALUES (p_login, p_email, p_password);

        SELECT LAST_INSERT_ID() AS user_id;
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE AuthenticateUser(
    IN p_login VARCHAR(30),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE stored_hash TEXT;
    DECLARE user_id INT;
   	DECLARE employee_id INT;
    DECLARE user_email VARCHAR(30);

    -- Получаем хеш пароля и данные пользователя из базы данных по логину
    SELECT u.id, email, password_hash, e.id INTO user_id, user_email, stored_hash, employee_id
    FROM users u
    LEFT JOIN employees e ON e.user_id = u.id
    WHERE login = p_login;
   
    -- Если пользователь не найден или хеш пароля равен NULL, возвращаем пустой результат
    IF stored_hash IS NULL THEN
        SELECT NULL AS id, NULL AS employee_id; -- Возвращаем пустые значения
    ELSE
        -- Сравниваем хеши паролей
        IF stored_hash = SHA2(p_password, 256) THEN
            -- Если пароль верный, возвращаем данные пользователя
            SELECT user_id as id, employee_id;
        ELSE
            SELECT NULL AS id, NULL AS employee_id; -- Пароль неверный
        END IF;
    END IF;
END //

DELIMITER ;


