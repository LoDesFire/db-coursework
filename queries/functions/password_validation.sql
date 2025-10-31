DELIMITER //

CREATE FUNCTION validate_password(password VARCHAR(255)) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    IF CHAR_LENGTH(password) <= 8 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be longer than 8 characters.';
    END IF;

    IF NOT (password REGEXP '[A-Z]' AND
            password REGEXP '[a-z]' AND
            password REGEXP '[0-9]' AND
            password REGEXP '[@#$%^&*(),.?":{}|<>!_-]') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.';
    END IF;

    RETURN TRUE;
END//

DELIMITER ;
